function [Formula, Reward,Theta] =ImitLearning(InitH,InitQ,temporal,T,N,Loop,inittheta,trajs,label,name)
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
ChartR=InitH;
AgendaR=InitQ; 
%% find the best formula with current parameters with in K derivation, which saved in tempH
for step=1:T

    
    for iter=1:Loop
     %   iter
        tempScore=[];
        tempreward=[];

    %% reset        
              AgendaC=[];
     %% find the oracle
     Chart=ChartR;
     Agenda=AgendaR; 
           for ih=1:(T-step+1)  %
                 LA= length(Agenda);
                 tempqs=zeros(LA,1); 
                   parfor iq=1:LA   
                    tempqs(iq)=  ExtractFeature(Agenda(iq))'*theta;  
                   end
              [score,ind]=max(tempqs);

    %  get the maxium score
              tempScore=[tempScore; score(1)];
              tempreward=[tempreward; RewardFunc(trajs,label,name, Agenda(ind(1)))];
             [Chart,Agenda] =NewToAgenda(Chart, Agenda,ind(end), temporal);
             AgendaC=[AgendaC, {Agenda}];

           end
    %% compress the history 
    % choose the derivation with max reward
         [rew,index]=max(tempreward);

     %% Get the Oracl to follows   
          Oracle=Chart(index(end));  

          Gradient=0;  % initialize the gradient
    %   
           beta=0;  % sample parameters
           eta=5.51;   % Learning rate
             for iik=1:length(AgendaC)  
               tf=IsSubFormula(Chart(iik+step-1),Oracle);  
               if tf
               Gradient= Gradient+  PolicyGrad(beta,theta,Chart(iik),AgendaC{iik},1);
               end
             end
             AgendaC=[];
         %% update parameters
         theta=theta+eta*(RewardFunc(trajs,label,name,Oracle))*Gradient;
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

