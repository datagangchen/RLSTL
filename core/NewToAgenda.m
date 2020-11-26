function [H,Q] =NewToAgenda(Chart, Agenda, derivation, temporal)
%Given a new derivation from Agenda, generate new derivations and add them
%back to agenda
% Chart:  The current chart, a set of tree
% Agenda: The current agenda, a set of tree 
% derivation: the derivation that is chosen, which is a index of agenda
% temporal: The  set of temporal operator . aw_[1 4]
% H     : The return chart
% Q     : The new agenda

%By:  Gang Chen
%Date: 2/11/2018

der=Agenda(derivation);  % get the derivation
 Agenda(derivation)=[];   % remove the derivation in agenda
%  Agenda=[];
parfor tem=1:size(temporal,1)
    Atreet=temporal(tem);
    treetemp=CombAtree(Atreet,der,Atreet.op);
    Agenda=[Agenda; treetemp];  % new agenda
end

if size(Chart,1)>0
    
    parfor index=1:size(Chart,1)
        Atree=Chart(index);    
        treetemp=CombAtree(Atree,der,3);      
        Agenda=[Agenda; treetemp];  % new agenda     
        treetemp=CombAtree(Atree,der,4);      
        Agenda=[Agenda; treetemp];  % new agenda            
        
    end
end

H=[Chart;der];

Q=Agenda;
end

