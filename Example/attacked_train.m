% function attacked_train
%
% Simulate behavior of an attacked train
%
% File: attacked_train.m
%
% Description: -1-: The purpose of this function is to simulate the
% behavior of an attacked train.
%
% Create: 02/04/2014
% 
% Last modified: 02/04/2014
%
% Author:   Zhaodan Kong
%           Boston University

clear all
close all

%
load('normal_signal','vdata','M')

%
N = 500; % number of sampled points
M_a = 2; % number of trajectories

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

%
figure
plot([1:N],v)
xlabel('time')
ylabel('velocity')

figure
plot([1:N],qv)
xlabel('time')
ylabel('velocity mode')

%
M = M+M_a;

save('normal_signal','vdata','M','N')
