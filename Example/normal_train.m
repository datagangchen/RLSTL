% function normal_train
%
% Simulate behavior of a normal train
%
% File: normal_train.m
%
% Description: -1-: The purpose of this function is to simulate the
% behavior of a normal train.
%
% Create: 02/04/2014
% 
% Last modified: 02/12/2014
%
% Author:   Zhaodan Kong
%           Boston University

clear all
close all

%
N = 500; % number of sampled points
M = 98; % number of trajectories


%
for k = 1:M
    % =============
    % initial state
    % =============
    v(1) = 20+5*rand(1); % velocity
    qv(1) = 1; % velocity mode
    qb(1,1:3) = ones(1,3); % brake mode
    bb(1,1:3) = zeros(1,3); % number of brakes
    b(1) = 0;
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

%
figure
plot([1:N],v)
xlabel('time')
ylabel('velocity')

figure
plot([1:N],b,'r-')
xlabel('time')
ylabel('breaks')

% figure
% plot([1:N],qv)
% xlabel('time')
% ylabel('velocity mode')
% 
figure
plot([1:N],qb)
xlabel('time')
ylabel('brake mode')

save('normal_signal','vdata','M','N')