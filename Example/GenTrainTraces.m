function [trajs,name,label] =GenTrainTraces(varargin)
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
if isempty(varargin)
   Plot=0;
else
    Plot=1;
    
end

%

%% generate normal trajectories

N = 500; % number of sampled points
M = 20; % number of trajectories


%
for k = 1:M
    % =============
    % initial state
    % =============
    v(1) = 20+5*rand(1); % velocity
    qv(1) = 1; % velocity mode
    qb(1,1:3) = ones(1,3); % brake mode
    bb(1,1:3) = zeros(1,3); % number of brakes
    b(1) = 1;
    c1(1,1:3) = zeros(1,3);
    c2(1,1:3) = zeros(1,3); % timers
    % ======
    % noises
    % ======
    n1 = normrnd(0,1,[1,N]);
    n2 = normrnd(0,0.1,[1,N]);
    n3 = normrnd(0,0.3,[1,N]);
    n4 = normrnd(0,3,[N,3]);
    n5 = normrnd(0,3,[N,3]);
    % ======
    % signal generation
    % ======
    for i = 1:N-1
        % train model
        switch qv(i)
            case 1,
                v(i+1) = 0.1353*v(i)+0.8647*(25+2.5*sin(i))+n1(i);
                if v(i+1)>28.5
                    qv(i+1) = 2;
                else
                    qv(i+1) = 1;
                end
            case 2,
                v(i+1) = v(i)-0.5*max([0,b(i)-1])+n2(i);
                if b(i)>0
                    qv(i+1) = 3;
                else
                    qv(i+1) = 2;
                end
            case 3,
                v(i+1) = v(i)-0.5*max([0,b(i)-1])+n2(i);
                if b(i)==0
                    qv(i+1) = 1;
                else
                    qv(i+1) = 3;
                end
        end
        % braking model
        for j = 1:3
            switch qb(i,j)
                case 1,
                    c1(i+1,j) = n4(i,j);
                    c2(i+1,j) = c2(i,j);
                    if v(i+1)>28.5
                        c1(i,j) = -abs(c1(i,j));
                        qb(i+1,j) = 2;
                        bb(i+1,j) = bb(i,j);
                    else
                        qb(i+1,j) = 1;
                        bb(i+1,j) = bb(i,j);
                    end
                case 2,
                    c1(i+1,j) = c1(i,j)+1;
                    c2(i+1,j) = c2(i,j);
                    if c1(i+1,j) > 1
                        if (v(i+1)<20)&(qv(i)~=2)
                            bb(i+1,j) = bb(i,j);
                            qb(i+1,j) = 1;
                        else
                            bb(i+1,j) = bb(i,j)+1;
                            qb(i+1,j) = 4;
                        end
                    else
                        qb(i+1,j) = 2;
                        bb(i+1,j) = bb(i,j);
                    end
                case 4,
                    c1(i+1,j) = c1(i,j);
                    c2(i+1,j) = n5(i,j);
                    if v(i+1)<20
                        c2(i+1,j) = -abs(c2(i,j));
                        qb(i+1,j) = 5;
                        bb(i+1,j) = bb(i,j);
                    else
                        qb(i+1,j) = 4;
                        bb(i+1,j) = bb(i,j);
                    end
                case 5,
                    c1(i+1,j) = c1(i,j);
                    c2(i+1,j) = c2(i,j)+1;
                    if c2(i+1,j) > 1
                        bb(i+1,j) = bb(i,j)-1;
                        qb(i+1,j) = 1;
                    else
                        bb(i+1,j) = bb(i,j);
                        qb(i+1,j) = 5;
                    end
            end
        end
        b(i+1) = bb(i+1,1)+bb(i+1,2)+bb(i+1,3);
    end
    v = v+n3;
    % =====
    % data storage
    % ====
    vdata(k).v = v;
end
%% generate attacked data

%N = 500; % number of sampled points
M_a =M; % number of attacked trajectories

%
for k = 1:M_a
    % =============
    % initial state
    % =============
    v(1) = 20+5*rand(1); % velocity
    qv(1) = 1; % velocity mode
    qb(1,1:3) = ones(1,3); % brake mode
    b = 0; % number of brakes
    % ======
    % noises
    % ======
    n1 = normrnd(0,1,[1,N]);
    n2 = normrnd(0,0.1,[1,N]);
    n3 = normrnd(0,0.5,[1,N]);
    % ======
    % signal generation
    % ======
    for i = 1:N-1
        % train model
        switch qv(i)
            case 1,
                v(i+1) = 0.1353*v(i)+0.8647*(25+2.5*sin(i))+n1(i);
                if v(i+1)>28.5
                    qv(i+1) = 2;
                else
                    qv(i+1) = 1;
                end
            case 2,
                v(i+1) = v(i)-0.5*max([0,b-1])+n2(i);
                if b>0
                    qv(i+1) = 3;
                else
                    qv(i+1) = 2;
                end
            case 3,
                v(i+1) = v(i)-0.5*max([0,b-1])+n2(i);
                if b==0
                    qv(i+1) = 1;
                else
                    qv(i+1) = 3;
                end
        end
    end
    v = v+n3;
    % ====
    % data storage
    % ====
  
    vdata(M+k).v = v;
end



time=1:1:N;
name={'velocity'};
temp=ones(M_a,1);
label=[temp;-temp];
trajs=[];
for ii=1:size(vdata,2)
    
    traj.time=time;
    traj.X=vdata(ii).v;
    traj.param=0;
    trajs=[trajs;traj];
end


if Plot
    figure
    for jj=1:M_a

        plot(time,vdata(jj).v,'r')
        hold on
        
    end
    
    for jj=M_a+1:2*M_a
        plot(time,vdata(jj).v,'g')
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
% c=colorbar;
% c.LineWidth=0.1;
% % c.Box='off';
% c.Label.String=' Violation   \rightarrow      Satisfaction';
% c.Label.FontSize = 12;
end

