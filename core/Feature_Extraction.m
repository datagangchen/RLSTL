function [feature] =Feature_Extraction(Atree,base);
% This function extract feature from the given formula save in Atree
% The feature for each dimension is as follows

%     base        : The base used for feature 
% Output: Feature Vector
%By:  Gang Chen
%Date: 2/11/2018
Num_rule=5;

feature=zeros(5*Num_rule,1);
if length(Atree.rule)<=Num_rule
    feature(1:length(Atree.rule))=Atree.rule;
else
    fprintf('too many production rules\n');
    return 
end

index=find(Atree.rule<3);
for ii=1:length(index)
  feature(Num_rule+2*index(ii)-1)= Atree.time(ii,1);
  feature(Num_rule+2*index(ii))= Atree.time(ii,2);
end
index=find(Atree.op>2);
for ii=1:length(index)
 feature(4*Num_rule+index(ii))= Atree.dir(ii);   
 feature(3*Num_rule+index(ii))= Atree.param_value(ii); 
end

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

