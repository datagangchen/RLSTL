function [T] =IsSubFormula(Atree1,Atree2)
%Investigate formula 1 is a sub derivation of formula 2
% Atree1 : formula 1
% Atree2 : formula 2
%T:        boolean output 
% example:
%         tree1={'A','B','C'};
%         tree2={'C','D','B','E'}
%         [T] =IsSubFormula(tree1,tree2)

%By:  Gang Chen
%Date: 2/11/2018


name1=Atree1.param_name;
name2=Atree2.param_name;
tf=zeros(size(name1));
for index=1:length(name1)
    
    s1=name1{index};
    temp = strcmp(s1,name2);
    tf(index)=max(max(temp));
end

% f1=ExtractFeature(Atree1);
% f2=ExtractFeature(Atree2);
% temp=f1-f2;
% temp=sum(temp.*temp);

T=sum(tf)==length(name1);

% T=sum(tf)>0;
end

