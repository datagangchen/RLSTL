load('data.mat');
load('Agenda.mat');

base=3;
fea=Feature_Extraction(Agenda(1),base);

feature=zeros(length(Agenda),length(fea));
summ=zeros(length(Agenda),1);
for index=1:length(Agenda)
    featuretemp=Feature_Extraction(Agenda(index),base)';
%     Agenda(index).op
%     summ(index)=sum(featuretemp.*featuretemp);
    feature(index,:)=Feature_Extraction(Agenda(index),base)';
%     Agenda(index).op
end
% 
% 
% [f,in]=sort(feature(:,1));
% 
% fea=zeros(length(Agenda),length(fea));
% 
% for index=1:length(in)
%     fea(index,:)=feature(in(index),:);
% end
% fea(:,10)=[];
% fea(:,[12,13])=[];
% [K] = kernel_se_normiso(fea , fea );
% 
% [a,b]=find(K==1);
% figure
% plot(a,b)
% size(a)
figure


for i=1:size(feature,1)

    plot(feature(i,:))
   hold on
   
end
