function [feature] =ExtractFeature(Agenda,base);
% This function extract feature from the given formula save in Atree
% The feature for each dimension is as follows
%     Feature vector theta:
%                         1----> start time
%                         2----> end time
%                         3----> maximum pi
%                         4----> minmun pi
%                         5----> Log # of time slots
%                         6----> Log # of predicate
%                         7----> Log # of conjuction
%                         8----> Log # of dis junction
%                         9----> Log # of G operator
%                         10---> Log # of F operator
%                         11---> Log # of predicates for -1 direction
%                         12---> Log # of predicates for 1 direction
%                         13---> entropy of predicates magnitude
%                         14---> entropy of time slots low bound
%                         15---> entropy of time slots up  bound
%     base        : The base used for feature 
% Output: Feature Vector
%By:  Gang Chen
%Date: 2/11/2018

Atree=Agenda(1);
feature=zeros(12,1);
feature(1)=5*(1+min(min(Atree.time)));
feature(2)=5*log(max(max(Atree.time)));
feature(3)=8*log(max(Atree.param_value)+1);
feature(4)=8*log(abs(min(Atree.param_value))+1);
num=find(Atree.rule==4);
feature(5)=log(length(num)+1);
num=find(Atree.dir==-1);
feature(6)=4*log(length(num)+2);  %dele
num=find(Atree.dir==1);
feature(7)=log(length(num)+1);
num=find(Atree.op==1);
feature(8)=.5*log(length(num)+1);
num=find(Atree.op==2);
feature(9)=log(length(num)+10);

num=Atree.rule;
temp1=linspace(1,1,length(num))*num;
feature(10)=10*log(abs(temp1)+1);
feature(11)=2*log(std(Atree.time(:,2)-Atree.time(:,1))+1);
feature(12)=10*log (std(Atree.param_value)+1);

Nub=2; % number of basis used 

switch base
    
    case 1  %Fourieer  Basis
        temp=[];
        unif=rescale(feature,0,1);
        LF=length(feature);
        parfor i=1:LF
            for j=0:Nub
             temp=[temp;cos(5*j*pi*unif(i))];   
            end
        end
        feature=temp;
        
    case 2  % Radia Basis Functions
        
        temp=[];
        unif=rescale(feature,0,1);
        LF=length(feature);
        Center=linspace(-4,0,Nub);
        parfor i=1:LF
            for j=1:Nub
             temp=[temp;exp(-(unif(i)-Center(j))^2/2)];   
            end
        end
        feature=temp;  
    otherwise
        
        
   feature=feature;
        
        
end
% f_mean=mean(feature);
% f_max=max(feature);
% f_min=min(feature);
% feature= (feature-f_mean)./(f_max-f_min);
norm=feature'*feature;
feature = feature./sqrt(norm);

feature=[feature;1];

end

