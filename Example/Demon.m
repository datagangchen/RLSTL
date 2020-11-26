%   vars = {'speed','rpm'};  % variables for signals values
%   params = {'vmax ','rpm_max'};  % parameters related to signal or to be                            % used in temporal logic formula
%   p0 = [ 0 0 ...      % default for initial values of signals 
%          1 2.5];    % default for parameters p0,p1 and p2
% 
%   Sys = CreateSystem(vars,params, p0); % creates the Sys structure
%   P = CreateParamSet(Sys);
%   P1 = Refine(P,2);  
%   %% generate trajectories
%   tspan=0:1/100:4; 
%   x1=sin(2*pi.*tspan);
%   x2=3*cos(2*pi.*tspan);  
%   X=[x1;x2]; 
%   traj.time=tspan;
%   traj.X=X;
%   traj.param=p0;  
%   P1.traj=traj;
%   P1.Xf=X(:,end);
% phi = '(alw (speed[t]<vmax)) and (alw (rpm[t]<rpm_max)) ';
% [phi1, phistruct] = QMITL_Formula('phi_tmp__', phi);
% val = QMITL_Eval(Sys, phi1, P1, P1.traj,0);

%% demon
close all;
clear all;
% [trajs,name,label] =GenTwoOrderTraces(); % genearte traces
load('data.mat');
load('Agenda.mat');
timeindices=3:max(trajs(1).time)/5:max(trajs(1).time);
magindices=0.5:0.21:1.5;
[Agenda] =GenInitATree(timeindices, magindices, name);
[top] =GenTemporal(timeindices);
InitH=[];

T=2;
base=1;
Loop=1;
DF=length(ExtractFeature(Agenda,base));
inittheta=randn(DF,1);
[Formula, Reward,Theta] =PG(InitH,Agenda,top,T,base,Loop,inittheta,trajs,label,name);
figure
plot(Reward)
[re,index]=max(Reward);
Formula(index(end)).ftree.get(1)
