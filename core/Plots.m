figure
plot(1:length(Reward),Reward','LineWidth',2)

xlabel('# of iterations')
ylabel('Classification error %')




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