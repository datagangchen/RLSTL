function [gradient] = PolicyGrad(theta,Atree,Agenda,base,index)
%Calculate the policy gradiend for formual Atree
% theat: the current parameters
% Atree: the chosen derivation/formula
% Agenda: the current Agenda
%index  : index for the kind of policy
% 1--> linear
% 2--> sigmoid
% 3--> gaussian 
%Output: the gradient


%By:  Gang Chen
%Date: 2/11/2018

numfor=length(Agenda);


switch index
    
    case 1
        mean=0;
        sum=0;
        parfor ii=1:numfor
            feature=ExtractFeature(Agenda(ii),base);
            sum=sum+exp(feature'*theta);
            mean=mean+exp(feature'*theta)*feature;
        end
        if sum==0
            mean=0;
        else
        mean=mean/sum;
        end
        gradient=ExtractFeature(Atree,base)-mean;
    case 2
        feature=ExtractFeature(Atree);
        mean=0;
        sum=0;

        parfor ii=1:numfor
             fea=ExtractFeature(Agenda(ii),base);
             pi=PolicySigmoid(fea, theta);
     
             sum=sum+pi;
            mean=mean+fea*exp(fea'*theta)/(1+exp(fea'*theta))^2;

        end
        
         if sum==0
            mean=0;
        else
        mean=mean/sum;
         end
        
        gradient=feature/(1+exp(feature'*theta))-mean;
    case 3
        
        
    otherwise
        
        disp('non existing rule!')      
        
        

end

