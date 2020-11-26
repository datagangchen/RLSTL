function [reward] =RewardFunc(trajs,label,name, Atree)
%This function calculate the perforamnce of the formula phi with tranining
%data. 
%label: label is the label vector for the data.
%trajs: the cell array , and cell data is structed.
%traj: the data struct which save trajectory data has fields as follows:
%       time: 1XN     time for trajectory
%       X:  MXN      trajectories
%       pram: 1XM   state value
%name : the signals's name for variables
%t : the time for signal values
%phi: The STL formula 
% phi: alw_[0 2](x>1)

%By:  Gang Chen

%Date: 2/12/2018



%% Computer robustness for each trajectory

robust=zeros(size(trajs,1),1);  % initialize the robustness vector

numTrajs = size(trajs,1);

%% Create a visual system

  vars = [name];  % variables for signals values
  
  params = [Atree.param_name];  % parameters related to signal or to be  

  % used in temporal logic formula
  init=zeros(1,length(name));
  p0 = [ init ...      % default for initial values of signals 
         Atree.param_value' ];    % default for parameters p0,p1 and p2

  Sys = CreateSystem(vars,params, p0); % creates the Sys structure
  P = CreateParamSet(Sys);
  P1 = Refine(P,2);
  
%% The formula 
  formula=Atree.ftree;
  phi=formula.get(1);
 [phi1, phistruct] = QMITL_Formula('phi_tmp__', phi);


for index=1:numTrajs% we loop on every traj in case we check more than one
 %% for each trajectory, compute values and times   

  traj=trajs(index);
  traj.param=p0;  
  P1.traj=traj;
  P1.Xf=traj.X(:,end);
 
robust(index) = QMITL_Eval(Sys, phi1, P1, P1.traj,0);
end
%     postive=robust>=0;
%     negtive=robust<0;
%     negtive=-negtive;
% 
%     lab=postive+negtive;
%     error=abs(lab-label)./2;
%     reward=1-sum(error)/length(label);
%  
        robust=robust.*label;  
        
        reward=min(robust);
        
        
    
end

