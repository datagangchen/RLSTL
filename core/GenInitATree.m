function [Atree] =GenInitATree(timeindices, magindices, signal)
%This function generate the element formula with terminal node, which
%distinguished with different time slots and amplitude slots

% timeindices: time index sequence, t=[t1,t2,...,tn]
% magindices:  magnitude index sequence p=[p1,p2,...,pn]


% signal:     the names for investigated signal, which is an array of cell
% Output :  a set of element formula saved in a tree struct has fields as
%                follows:
%               -tree: the structure of the formula
%               -rule: the sequence of rule used to generate the formula,
%                  which uses index to denotes the rule as follows:
%                      1:A-->  \square A
%                      2:A-->   \diamond A
%                      3:A-->A v B
%                      4:A--> A ^ B
%                      5:A--> \mu
%               -time: the time bound sequence in the formula
%               -dir:  indicate < />= in predicate 
%                            -1---  <
%                            1---  >=
%               -param_vale:  the magnitude sequence of the predicate
%               -param_name:  the name for the parameters
%               -operator: the temporal operator sequence in the formula which use             
%                          index to denote  the operator
%                         1---  \square
%                         2---- \diamond
%               

%By:  Gang Chen

%Date: 2/11/2018

%% example output
%  alw_[0,1](x>1)  ev_[0,1](x<2)

%% Generate time slots

slots=[];
for index=1:length(timeindices)
       for ii=index+1:length(timeindices)
           
           slot=[timeindices(index),timeindices(ii)];
           slots=[slots;slot];
       end
end
%% Generate formula 
Atree=[];
pum=0;
for i_name=1:length(signal)

    for i_slot=1:size(slots,1)

        for i_mag=1:length(magindices)
            
            name=signal{i_name};
            t1=num2str(slots(i_slot,1));
            t2=num2str(slots(i_slot,2));
            comma=',';           

            al='alw_[';
            ev='ev_[';
            rb=']';
            leq='<';
            geq='>=';
            lbr='(';
            rbr=')';      
            ts='[t]';
%% inital the two trees struct
            tree1=tree;
            tree2=tree;
            Atree1.ftree=tree1;
            Atree1.rule=[];
            Atree1.time=[];
            Atree1.dir=[];
            Atree1.param_name=[];
            Atree1.param_value=[];
            Atree1.op=[];
            Atree2=Atree1;
%             Atree0=Atree1;
            
            
%% assign data to Atree
            
            f1=[al t1 comma t2 rb ];
            rule1=[1];
            time1=slots(i_slot,:);
            dir1=[];
            param_name1=[];
            param_value1=[];
            op1=[];
  %% generate the first Atree
          Atree1.ftree=tree(f1);
          Atree1.rule=[rule1];
          Atree1.time=[time1];
          Atree1.dir=[ dir1];
          Atree1.param_name=[param_name1];
          Atree1.param_value=[param_value1];
          Atree1.op=[Atree1.op; op1];
          
  %%  assign data to Atree         
            pum=pum+1;
            pname=['pi' num2str(pum)];
            f2=[lbr name ts leq pname rbr ];
            rule2=[];
            time2=[];
            dir2=[-1];
            param_name2={pname};
            param_value2=magindices(i_mag);
            op2=[];
            
   %% generate the first Atree     
          Atree2.ftree=tree(f2);
          Atree2.rule=[rule2];
          Atree2.time=[time2];
          Atree2.dir=[dir2];
          Atree2.param_name=[param_name2];
          Atree2.param_value=[param_value2];
          Atree2.op=[op2];
          
          Atreetemp=CombAtree(Atree1,Atree2,1);
         
          Atree=[Atree; Atreetemp];
          
          
   %% The second formula
            pum=pum+1;
            pname=['pi' num2str(pum)];  
            f3=[lbr name ts geq pname rbr ];
            rule2=[];
            time2=[];
            dir2=[1];
            param_name2={pname};
            param_value2=magindices(i_mag);
            op2=[];          
          Atree2.ftree=tree(f3);
          Atree2.rule=[rule2];
          Atree2.time=[ time2];
          Atree2.dir=[dir2];
          Atree2.param_name=[param_name2];
          Atree2.param_value=[ param_value2];
          Atree2.op=[];         
          Atreetemp=CombAtree(Atree1,Atree2,1);
          
          Atree=[Atree; Atreetemp];       
          
  %% The third formula
            pum=pum+1;
            pname=['pi' num2str(pum)];   
            f4=[  ev t1 comma t2 rb ];
            rule1=[2];
            time1=slots(i_slot,:);
            dir1=[];
            param_name1=[];
            param_value1=[];
            op1=[];
          Atree1.ftree=tree(f4);
          Atree1.rule=[ rule1];
          Atree1.time=[time1];
          Atree1.dir=[ dir1];
          Atree1.param_name=[param_name1];
          Atree1.param_value=[param_value1];
          Atree1.op=[];           
          
            f3=[lbr name ts geq pname rbr ];
            rule2=[];
            time2=[];
            dir2=[1];
            param_name2={pname};
            param_value2=magindices(i_mag);
            op2=[];          
          Atree2.ftree=tree(f3);
          Atree2.rule=[rule2];
          Atree2.time=[time2];
          Atree2.dir=[dir2];
          Atree2.param_name=[param_name2];
          Atree2.param_value=[ param_value2];
          Atree2.op=[];            
          
          
          Atreetemp=CombAtree(Atree1,Atree2,2);
          Atree=[Atree; Atreetemp];       
          
          
          
          %% The forth formula
          
            pum=pum+1;
            pname=['pi' num2str(pum)];  
            f2=[lbr name ts leq pname rbr ];
            rule2=[];
            time2=[];
            dir2=[-1];
            param_name2={pname};
            param_value2=magindices(i_mag);
            op2=[];         
          Atree2.ftree=tree(f2);
          Atree2.rule=[ rule2];
          Atree2.time=[time2];
          Atree2.dir=[dir2];
          Atree2.param_name=[param_name2];
          Atree2.param_value=[param_value2];
          Atree2.op=[];         
          Atreetemp=CombAtree(Atree1,Atree2,2);
          Atree=[Atree; Atreetemp];     
          
            
            
          
            
            
%             F1=[lbr al t1 comma t2 rb lbr name ts leq pi rbr rbr];
%             
%             F2=[lbr al t1 comma t2 rb lbr name ts geq pi rbr rbr];
%             
%             F3=[lbr ev t1 comma t2 rb lbr name ts leq pi rbr rbr];
%             
%             F4=[lbr ev t1 comma t2 rb lbr name ts geq pi rbr rbr];
     
            
        end
    end
end



end

