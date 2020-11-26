function plot_traj()
%UNTITLED Summary of this function goes here
close all;
clear all;
% [trajs,name,label] =GenTwoOrderTraces(); % genearte traces
load('data.mat');
load('Agenda.mat');
figure

for index=1:length(label)
    
   if index>50
       
       plot(trajs(index).X,'-r');
       hold on 
   else
       plot(trajs(index).X,'.-g');
       hold on
   end
end

end

