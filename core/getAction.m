function [qvalue,index] = getAction(Chart,Agenda,pd,theta,base, temporal)
%%This function  get the next action with a given state and action
% state : the current state
% Action: The action set avaialable for current state
% pd    : e distribution specified by the probability distribution object pd
%theta:  the weight for the feature
%% Output:
%     qvalue:  the value for the action
%     index:  the action's index chosen 

%By:  Gang Chen
%Date: 3/16/2018

%% random sample
Ls=length(Agenda);
tvalue=zeros(Ls,1);
Y = random(pd);
if Y==1
  
    index= randsample(length(Agenda),1);
    [ChartR,AgendaR] =NewToAgenda(Chart, Agenda,index, temporal);
    qvalue=PolicyLinear(ExtractFeature(AgendaR,base),theta); % e-greedy
    return;
end
%% greedy search
parfor iq=1:Ls  
 [ChartR,AgendaR] =NewToAgenda(Chart, Agenda,iq, temporal);
  tvalue(iq)=PolicyLinear(ExtractFeature(AgendaR,base),theta); % e-greedy
end

[maxq,ind]=max(tvalue);
index=ind(1);
qvalue=maxq(1);

end

