function [Formula, Reward,Theta] =PG(InitH,InitQ,temporal,T,base,Loop,inittheta,trajs,label,name)
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
beta=0;
Formula=[];
Reward=[];
Theta=[];

%% find the best formula with current parameters with in K derivation, which saved in tempH

lamda=0.9;
alph=2*10^(-1);%learning rate
for iter=1:Loop
     %% reset the running process  initalize S
     Chart=InitH;
     Agenda=InitQ; 
     ActionC=[];
     AgendaC=[];
     Tempreward=[];
     for step=1:T   % run for T steps
     %   iter
      [indexa] = Action(Agenda,theta(:,step),base);
      ActionC=[ActionC;{Agenda(indexa)}];
      AgendaC=[AgendaC;{Agenda}];
      [Chart,Agenda] =State(Chart, Agenda,indexa, temporal);
  
      reward=RewardFunc(trajs,label,name, Agenda(indexa));  

      Tempreward=[Tempreward;reward];
     end
     
     for index =1:T
       Rt=sum(Tempreward(index:end));
       delta=PolicyGrad(theta(:,index),ActionC{index},AgendaC{index},base,1);
       theta(:,index)=theta(:,index)+alph*lamda^(index)*Rt*delta;
     end
     sum(abs(delta))
  
         %% Output the results
       [mrew,inde]= max(Tempreward);
       Formula=[Formula,ActionC{inde(1)}];
       Reward=[Reward;mrew];
       ActionC{end}.ftree.get(1)
       iter
     end

end






