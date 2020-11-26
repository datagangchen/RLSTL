function [Formula, Reward,Theta] =RL(InitH,InitQ,temporal,T,base,Loop,inittheta,trajs,label,name)
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
ChartR=InitH;
AgendaR=InitQ; 
eta=1;  %learning rate
lamda=0.9;
alph=0.2;
pd = makedist('Binomial','N',1,'p',0.2);
for iter=1:Loop
     %% reset the running process  initalize S
     Chart=InitH;
     Agenda=InitQ; 
    calph=3*alph;
     for step=1:T   % run for T steps
     %   iter
      [qvalue,index] = getAction(Chart,Agenda,pd,theta,base, temporal);
       fea=ExtractFeature(Agenda(index),base);
       if step==T
       reward=RewardFunc(trajs,label,name, Agenda(index));  
       gphi=fea;  % gradient of qfunction
       delta=reward-PolicyLinear(fea,theta); %different
       theta=theta+calph*delta*gphi;  
       
       
       %% Output the results
       Formula=[Formula,Agenda(index)];
       Theta=[Theta;theta'];    
       Reward=[Reward;reward];
       end
     
  %% calculate policy gradient
      reward=-4;%RewardFunc(trajs,label,name, Agenda(index));  
      gphi=fea;  % gradient of qfunction
      delta=reward+lamda*qvalue -PolicyLinear(fea,theta); %different
     [Chart,Agenda] =NewToAgenda(Chart, Agenda,index, temporal);

     end
  iter 
end




end

