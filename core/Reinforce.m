classdef Reinforce
    
    properties(SetAccess = private, Hidden)
        state % the current state
        temporal
        action % the current action taken for the mdp
        step  % the currrent step in a epsido
        final_flag   % is the final step
        rewards  %  the reward for last action
        history
        weight   % the weight for feature
        featurebase
        T      % the total round
        rate
        discount
        Num_rule
        spanOrder
    end
    
    
    methods
        
        function obj = reset(obj,arg1,arg2,varargin)
            obj.state.Q = arg1;
            obj.state.H=[];
            obj.action =[];
            obj.step =0;
            obj.final_flag=false;
            obj.history=[];
            obj.rewards=[];
            obj.temporal=arg2;
        end
        
        function obj = initialize(obj,arg1,arg2,varargin)
            obj.state.Q = arg1;
            obj.state.H=[];
            obj.action =[];
            obj.step =0;
            obj.final_flag=false;
            obj.history=[];
            obj.rewards=[];
            obj.T = arg2;
            obj.Num_rule=4;
            obj.spanOrder=2;
            if length(varargin)>1
            obj.rate = varargin{1};
            obj.discount=varargin{2};
            else
            obj.rate = 10^(-4);
            obj.discount=0.9;               
            end
            
            DF=length(obj.extraction(arg1(1)));
            obj.weight=zeros(DF,1);

        end
        
        function obj = act(obj,arg1)
            Chart=obj.state.H;
            Agenda=obj.state.Q;
            der=Agenda(arg1);  % get the derivation
            Agenda(arg1)=[];   % remove the derivation in agenda
            parfor tem=1:size(obj.temporal,1)
                Atreet=obj.temporal(tem);
                treetemp=CombAtree(Atreet,der,Atreet.rule);
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
            obj.history=[obj.history; {[{obj.state},{der}]}];
            obj.state.H=[Chart;der];
            obj.state.Q=Agenda;
            obj.step=obj.step+1;
        end
        
        function obj = reward(obj,arg1,trajs,label,name)
            obj.rewards =[obj.rewards;RewardFunc(trajs,label,name, obj.state.Q(arg1))];
        end
        
        function obj=policy(obj)
            Ls=length(obj.state.Q);
            prop=zeros(Ls,1);
            fweight=obj.weight;
            
            %% greedy search
            parfor index=1:Ls  
              feature=obj.extraction(obj.state.Q(index)); 
              prop(index)=exp(feature'*fweight);
            end
            prop=prop./sum(prop);
            obj.action=randsample(Ls,1,true,prop);
            
            
        end
        
        function [grad]=gradient(obj,state,arg1)
            mean=0;
            sum=0;
            numfor = length(state.Q);
            parfor ii=1:numfor
                feature=obj.extraction(state.Q(ii));
                sum=sum+exp(feature'*obj.weight);
                mean=mean+exp(feature'*obj.weight)*feature;
            end
            if sum==0
                mean=0;
            else
            mean=mean/sum;
            end
            grad = obj.extraction(arg1)-mean;    
        end
        
        function obj = pglearning(obj)
             for index =1:obj.T
               Rt=sum(obj.rewards(index:end));
               delta=obj.gradient(obj.history{index}{1},obj.history{index}{2});
               obj.weight=obj.weight+obj.rate*obj.discount^(index)*Rt*delta;
             end
        end
        function feature = extraction(obj,Atree)
            
            feature=zeros(5*obj.Num_rule,1);
            if length(Atree.rule)<=obj.Num_rule
                feature(1:length(Atree.rule))=Atree.rule;
            else
                fprintf('too many production rules\n');
                return 
            end

            index=find(Atree.rule<3);
            for ii=1:length(index)
              feature(obj.Num_rule+2*index(ii)-1)= Atree.time(ii,1);
              feature(obj.Num_rule+2*index(ii))= Atree.time(ii,2);
            end
            index=find(Atree.op>2);
            dif=length(Atree.rule)-length(Atree.op);
            if dif<0
                Atree.ftree.get(1)
                Atree
                Atree.op
            end
            for ii=1:length(index)
             feature(4*obj.Num_rule+index(ii))= Atree.dir(ii);   
             feature(3*obj.Num_rule+index(ii))= Atree.param_value(ii); 
            end
            feature =obj.polyspan(feature);
            feature=[feature;1];
        end
        function  feature = polyspan(obj,arg1)
            shapefcn = polyBasis('canonical',obj.spanOrder);
            feature=[];
            for index = 1: length(arg1)
                feature=[feature; shapefcn(arg1(index))'];              
            end
           
        end
        
        
    end
    
end