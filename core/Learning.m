function [Formula, Reward,Theta] =Learning(InitH,InitQ,temporal,T,N,Loop,inittheta,trajs,label,name)
%This function learning the parameters for scoring function with imitation
%learning

% input:
% 
%         initH: initial Chart, which is empty
%         initQ: initial Agenda
%         T:     the limitation for chart's derivations/steps of running
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
beta=0;
Formula=[];
Reward=[];
Theta=[];

%% find the best formula with current parameters with in K derivation, which saved in tempH
ChartR=InitH;
AgendaR=InitQ; 

    
for iter=1:Loop
    
 for step=1:T   
 %   iter
    tempreward=[];
   % AgendaC=[];
    Gradient=0; 
    GradientN=0; 
    eta=1;
 

    
   for in=1:N  % number of running  
    %% reset    
    
     Chart=ChartR;
     Agenda=AgendaR; 
       for ih=1:(T-step+1)  %
        
          LA= length(Agenda);
          if ih>1
          tempqs=zeros(LA,1); 
               parfor iq=1:LA   
                tempqs(iq)=PolicyLinear(ExtractFeature(Agenda(iq)),theta);%  ExtractFeature(Agenda(iq))'*theta;
                
               end
               [score,ind]=max(tempqs);
          else
              % random initial action
              rn=randn(LA,1);
              rn=floor(rescale(rn))*round(LA/2);
              if LA>ih
              ind=rn(ih)+1;
              else
                  ind=rn(1)+1;
              end
              
          end
         
      %  get the maxium score
%         tempScore=[tempScore; score(1)];
          tempreward=[tempreward; RewardFunc(trajs,label,name, Agenda(ind(1)))];
       %  Agenda(ind(end)).ftree.get(1)
           %% calculate policy gradient
          Gradient=Gradient+PolicyGrad(beta,theta,Agenda(ind(end)),Agenda,1);     
         [Chart,Agenda] =NewToAgenda(Chart, Agenda,ind(end), temporal);
  %       AgendaC=[AgendaC, {Agenda}];

       end
   %   [iir,iid]= max(tempreward);
       GradientN=tempreward(end)*Gradient+GradientN;
       tempreward=[];
       
   end
  %% update the parameters 
    theta=theta+eta*GradientN;
end


%% update state

         LA= length(AgendaR);
         tempqs=zeros(LA,1); 
           parfor iq=1:LA   
            tempqs(iq)=  ExtractFeature(AgendaR(iq))'*theta;  
           end
         [score,ind]=max(tempqs);
         [ChartR,AgendaR] =NewToAgenda(ChartR, AgendaR,ind(end), temporal);


         Formula=[Formula; ChartR(end)];
         Reward=[Reward; RewardFunc(trajs,label,name,ChartR(end))];
         
end


end

