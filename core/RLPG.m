function [Formula, Reward] =RLPG(InitH,InitQ,temporal,T,base,Loop,inittheta,trajs,label,name)
%This function learning the parameters for scoring function with
%reinforcement learning


% input:
% 
%         initH: initial Chart, which is empty
%         initQ: initial Agenda
%         T:     the limitation for chart's derivations/steps of running %
%         number of horizon
%         N:     The number of running for estimation of espectation for
%         policy
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



theta=inittheta;
Formula=[];
Reward=[];


%% find the best formula with current parameters with in K derivation, which saved in tempH

lamda=1;

calph=1*10^(-12);
pd = makedist('Binomial','N',1,'p',0.2);
for iter=1:Loop  % number of eisode
     %% reset the running process  initalize S
     Chart=InitH;
     Agenda=InitQ; 

     %  initilize the action sequence and reward sequence
        Action=[];
        Tempward=[];     
        AgendaR=[];
     
     for step=1:T   % run for T steps to get action state reward pairs
        LA=length(Agenda);
        tempqs=zeros(LA,1);
        parfor index=1:LA
            fea=ExtractFeature(Agenda(index),base);
            tempqs(index)=PolicyLinear(fea,theta(:,step));
        end
        [value,max_index]=max(tempqs);
        reward=RewardFunc(trajs,label,name, Agenda(max_index(1)));  
       
        
        Tempward=[Tempward; reward];
        Action=[Action; {Agenda(max_index(1))}];
        AgendaR=[AgendaR;{Agenda}];
       [Chart,Agenda] =NewToAgenda(Chart, Agenda,max_index(1), temporal);
     end
%%  Learning The parameters
       Action{end}.ftree.get(1)
    for index=1:T
        Rt=sum(Tempward(index:end));
%         Rt=Tempward(end);
        pg=PolicyGrad(theta(:,index),Action{index},AgendaR{index},base,1);
        theta(:,index)=theta(:,index)+calph*lamda^index*Rt*pg;
    end
     sum(abs(pg))
 
  %% calculate policy gradient
    Formula=[Formula;Action(end)];
    Reward=[Reward;Tempward(end)];
iter
 end




end

