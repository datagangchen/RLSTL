function [trajs,name,label] =GenHighOrderTraces()
%The function generate the traces for the learning algorithm
% Output:
%label: label is the label vector for the data.
%trajs: the cell array , and cell data is structed.
%traj: the data struct which save trajectory data has fields as follows:
%       time: 1XN     time for trajectory
%       X:  MXN      trajectories
%       pram: 1XM   state value
%name : the signals's name for variables

%By:  Gang Chen
%Date: 2/12/2018

%% generate attacked data
varargin=[1];
if isempty(varargin)
   Plot=0;
else
    Plot=1;
    
end

%
   

N=50;  % number of trajectories  for normal and anormal data

Fs = 20;
dt = 1/Fs;
M = 500;
t = dt*(0:M-1);
%% generate normal trajectories
nor=normrnd(0,0.3,[1,N]);
data.x=[];

for ii=1:N

a = [-0.5572,-0.7814;0.7814+nor(ii),0];
b=[1;0];
c = [1.9691+3*nor(ii),6.4493];
sys = ss(a,b,c,0);
[y]=step(sys,t);
data(ii).x=y';
end

%% generate anormal trajectories
anor=normrnd(0,0.1,[1,N]);


for ii=1:N

a = [-0.5572,-0.7814;0.7814,0+nor(ii)];
b=[1;0];
c = [1.9691,6.4493];
sys = ss(a,b,c,0);
[y]=step(sys,t);

data(ii+N).x=y';
end


time=t;
name={'step'};
temp=ones(N,1);
label=[temp;-temp];
trajs=[];

for ii=1:size(data,2)
    
    traj.time=time;
    traj.X=data(ii).x;
    traj.param=0;
    trajs=[trajs;traj];
end


if Plot
    figure
    for jj=1:N

        plot(time,data(jj).x,'r')
        hold on
        
    end
    
    for jj=N+1:2*N
        plot(time,data(jj).x,'g')
        hold on        
    end
    hold off
    
    xlabel('time')
    ylabel('velocity mode')
        
    
    
    
    
end

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [3 3 8 6]);
set(gcf, 'Alphamap',0.01);
set(gcf, 'Colormap', cool);
set(gcf,'Units', 'inches');
set(gcf,'Position',[2, 2, 6, 6]);
set(gcf,'OuterPosition',[1,1,7,7])
set(gcf,'Color','white')
set(gca,'LineWidth',1)
set(gca,'FontUnits','points')
set(gca,'FontSize',20);
set(gca,'Color','none');
set(gca,'Box','on');
    
    

end