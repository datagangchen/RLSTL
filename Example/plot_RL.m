t=1:1:1000;
N=length(t);
anor1=normrnd(0,0.02,[1,N]);
r1=0.2-exp(-.003*t)+anor1;
anor2=normrnd(0,0.02,[1,N]);
r2=0.2-exp(-.004*t-0.0001*t.^2)+anor2;
anor3=normrnd(0,0.02,[1,N]);
r3=0.2-exp(-.003*t-0.000005*t.^2)+anor3;
r4=0.21*ones(1,length(t));

plot(t,r1,'-r',t,r2,'-b',t,r3,'-g',t,r4,'--k','LineWidth',1)
xlabel('Episode');
ylabel('Total reward on episode');

xt = [200 600 250  10];
yt = [0.3 -.05 0.1 0.24];
str = {'\alpha=2^{-3}','\alpha=2^{-4}','\alpha=2^{-2}','v_{*}(s_{0})'};
text(xt(1),yt(1),str(1),'Color','blue','FontSize',16)
text(xt(2),yt(2),str(2),'Color','red','FontSize',16)
text(xt(3),yt(3),str(3),'Color','green','FontSize',16)
text(xt(4),yt(4),str(4),'Color','black','FontSize',16)





set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [3 3 8 6]);
set(gcf, 'Alphamap',0.01);
set(gcf, 'Colormap', cool);
set(gcf,'Units', 'inches');
set(gcf,'Position',[2, 2, 6, 6]);
set(gcf,'OuterPosition',[1,1,7,7])
set(gcf,'Color','white')
set(gca,'LineWidth',1)
set(gca,'FontUnits','points')
set(gca,'FontSize',20);
set(gca,'Color','none');
set(gca,'Box','on');