function [top] =GenTemporal(timeindices)
%Generate the temporal operator with time bound parameters
% timeindices: time index sequence, t=[t1,t2,...,tn]
% Output :  a set of temporal operator with time bounds 

%By:  Gang Chen

%Date: 2/11/2018

%% output example 
% alw_[1, 2] ev_[2, 3]
%% Generate time slots

slots=[];
for index=1:length(timeindices)
       for ii=index+1:length(timeindices)       
           slot=[timeindices(index),timeindices(ii)];
           slots=[slots;slot];
       end
end

%% Generate temporal operators
top=[];
for i_slot=1:length(slots)
    
            al='alw_[';
            ev='ev_[';
            rb=']';
            t1=num2str(slots(i_slot,1));
            t2=num2str(slots(i_slot,2));
            comma=',';   
            f1=[al t1 comma t2 rb];
            f2=[ev t1 comma t2 rb];
  
            
            
            tree1=tree;
            Atree1.ftree=tree1;
            Atree1.rule=[];
            Atree1.time=[];
            Atree1.dir=[];
            Atree1.param_name=[];
            Atree1.param_value=[];
            Atree1.op=[];
            
            
            rule1=[1];
            time1=slots(i_slot,:);
            dir1=[];
            param_name1=[];
            param_value1=[];
            op1=[];
  %% generate the first Atree
          Atree1.ftree=tree(f1);
          Atree1.rule=[rule1];
          Atree1.time=[ time1];
          Atree1.dir=[dir1];
          Atree1.param_name=[param_name1];
          Atree1.param_value=[param_value1];
          Atree1.op=[ op1];
          
          top=[top; Atree1];
          Atree1.ftree=tree(f2);
          Atree1.rule=[2];
          Atree1.op=[];
          top=[top; Atree1];
          
end


end

