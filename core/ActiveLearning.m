function [Formula, Reward,Theta] =ActiveLearning(InitH,InitQ,temporal,lbound,ubound,T,Loop,trajs,label,name)
%This function learning the parameters for scoring function with imitation
%learning

% input:
% 
%         initH: initial Chart, which is empty
%         initQ: initial Agenda
%         T:     the length of epsiode
%         Loop:  the loop for learning the parameters
%         inittheta: the initial parameters
%         temporal: the temporal operators 
%         label: label is the label vector for the data.
%         trajs: the cell array , and cell data is structed.
%         traj: the data struct which save trajectory data has fields as follows:
%               time: 1XN     time for trajectory
%               X:  MXN      trajectories
%               pram: 1XM   state value
%         name : the signals's name for variables

% Output:
% 
%         formula: the sequence of formula learned
%         reward: the sequence of reward
%         Theta: the sequence of learned parameters



%By:  Gang Chen
%Date: 2/12/2018

Formula=[];
Reward=[];
Theta=[];
base=1;
fun=@(x) Potential(InitH,InitQ,temporal,T,x,trajs,label,name);
%% find the best formula with current parameters with in K derivation, which saved in tempH
[ Xs, Xt, Yt] = gp_sample_hyper(fun,lbound,ubound );
[Xtnew,Ytnew,Sigma] = ActiveGpOptHyper( fun,Xt, Yt, Xs,Loop,'opthyper',false,'algo', 'gpucb');

%% find the formula 
Reward=Ytnew;
Theta=Xtnew;

% for index=1: size(Xtnew,1)
theta=Xtnew(end,:);
    Chart=InitH;
     Agenda=InitQ; 
     
     for step=1:T   % run for T steps
     %   iter
              LA= length(Agenda);
              tempqs=zeros(LA,1); 
          parfor iq=1:LA   
             [ChartR,AgendaR] =NewToAgenda(Chart, Agenda,iq, temporal);
             tempqs(iq)=PolicyLinear(ExtractFeature(AgendaR,base),theta'); % e-greedy
          end   
              [score,ind]=max(tempqs);
           %  Agenda(ind(end)).ftree.get(1)   
           
           if step==T
           Formula=[Formula;Agenda(ind(1))];    
           end
           [Chart,Agenda] =NewToAgenda(Chart, Agenda,ind(end), temporal);  
     end
% end

end


function [reward]=Potential(InitH,InitQ,temporal,T,theta,trajs,label,name)

%This function learning the parameters for scoring function with imitation
%learning

% input:
% 
%         initH: initial Chart, which is empty
%         initQ: initial Agenda
%         T:     the length of epsiode
%         Loop:  the loop for learning the parameters
%         inittheta: the initial parameters
%         temporal: the temporal operators 
%         label: label is the label vector for the data.
%         trajs: the cell array , and cell data is structed.
%         traj: the data struct which save trajectory data has fields as follows:
%               time: 1XN     time for trajectory
%               X:  MXN      trajectories
%               pram: 1XM   state value
%         name : the signals's name for variables

% Output:
% 

%         reward: the reward for 


     %% reset the running process
     base=1;
     Chart=InitH;
     Agenda=InitQ; 
     
     for step=1:T   % run for T steps
     %   iter
              LA= length(Agenda);
              tempqs=zeros(LA,1); 
              parfor iq=1:LA   
                 [ChartR,AgendaR] =NewToAgenda(Chart, Agenda,iq, temporal);
                 tempqs(iq)=PolicyLinear(ExtractFeature(AgendaR,base),theta'); % e-greedy
              end   
              [score,ind]=max(tempqs);
           %  Agenda(ind(end)).ftree.get(1)   
           if step==1
               
           ind(1)
           end
           if step==T
           reward=RewardFunc(trajs,label,name, Agenda(ind(1)))+0.1*randn(1); 
           end
        [Chart,Agenda] =NewToAgenda(Chart, Agenda,ind(end), temporal);
             
     end

end
