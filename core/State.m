function [H,Q] =State(Chart, Agenda, derivation, temporal)
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
Agendat=Agenda;
%  Agenda=[];
parfor tem=1:size(temporal,1)
    Atreet=temporal(tem);
    treetemp=CombAtree(Atreet,der,Atreet.op);
    Agenda=[Agenda; treetemp];  % new agenda
end
LA=size(Agendat,1);
    parfor index=1:LA
        Atree=Agendat(index);    
        treetemp=CombAtree(Atree,der,3);      
        Agendat(index)=treetemp;  % new agenda     
        treetemp=CombAtree(Atree,der,4);      
        Agenda=[Agenda; treetemp];  % new agenda            
        
    end

Agenda(1:LA)=Agendat;

H=[Chart;der];

Q=Agenda;
end

