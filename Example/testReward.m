  vars = [{'step'},{'rpm'}];  % variables for signals values
  params = [{'pi1 '},{'rpm_max'}];  % parameters related to signal or to be                            % used in temporal logic formula
  p0 = [ 0 0 ...      % default for initial values of signals 
         1 2.5];    % default for parameters p0,p1 and p2

  Sys = CreateSystem(vars,params, p0); % creates the Sys structure
  P = CreateParamSet(Sys);
  P1 = Refine(P,2);  
  %% generate trajectories
  tspan=0:1/100:4; 
  x1=sin(2*pi.*tspan);
  x2=3*cos(2*pi.*tspan);  
  X=[x1;x2]; 
  traj.time=tspan;
  traj.X=X;
  traj.param=p0;  
  P1.traj=traj;
  P1.Xf=X(:,end);
phi = '(alw_[0,1] (step[t]<pi1)) and (alw_[1,2] (rpm[t]<rpm_max)) ';

%phi='alw_[1,2.5]((ev_[1,2.5](step[t]>=pi1)) or (alw_[1,2.5]ev_[1,2.5](step[t]>=pi1)))';
%phi='alw_[0,1](step[t]<pi1)';

[phi1, phistruct] = QMITL_Formula('phi_tmp__', phi);
val = QMITL_Eval(Sys, phi1, P1, P1.traj,0);

val