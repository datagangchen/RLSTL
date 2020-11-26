function [index] =Action(Agenda,theta,base)
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
prop=zeros(Ls,1);
%% greedy search
parfor index=1:Ls  
  value=PolicyLinear(ExtractFeature(Agenda(index),base),theta);
  prop(index)=exp(value);
end

prop=prop./sum(prop);

Y=randsample(Ls,1,true,prop);
index=Y;

% std(prop)

end

