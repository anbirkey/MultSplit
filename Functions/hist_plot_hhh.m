function [] = hist_plot_hhh(model,step)

%% Make the figure;

f=figure;
f.Units='inches';
f.Position=[0.4 0.4 12 8];

model=sortrows(model,7);
bf=model((model(:,8)<=min(model(:,8))+4),:);

%% Do the Fast Directions

phi1=model(1,1);
phi2=model(1,3);
phi3=model(1,5);

% Find a nice range for the ylim

z1=histcounts(model(:,1),length(phi_mod));
z2=histcounts(model(:,3),length(phi_mod));
z3=histcounts(model(:,5),length(phi_mod));
z=max([z1 z2 z3]);

scl1=z+1*10^(numel(num2str(z))-1);

% Same for bf

z1=histcounts(bf(:,1),length(phi_mod));
z2=histcounts(bf(:,3),length(phi_mod));
z3=histcounts(bf(:,5),length(phi_mod));
z=max([z1 z2 z3]);

scl2=z*0.05*10^(numel(num2str(z))-1);

% Phi Lower
g1=subplot(231);
g=get(g1,'Position');
np=[g(1)+0.05 g(2) g(3) g(4)];
set(g1,'Position',np, 'FontSize', 12);

yyaxis left
histogram(model(:,1),phi_mod,'FaceAlpha',0.3);
title('Phi Lower (°)', 'FontSize', 14);

if max(model(:,1))<=90
    xlim([-90 90]);
elseif max(model(:,1))>90
    xlim([0 180]);
end

ylim([0 scl1]);
ylabel('Robust Models', 'FontWeight', 'bold');

% Best Fit Lower
l=line([phi1 phi1],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;
l=line([140 140],ylim,'Color','r','LineWidth',2);

yyaxis right
histogram(bf(:,1),phi_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
yticks([]);

%set(gca,'FontName','Times');

% Phi Middle
g2=subplot(232);
g=get(g2,'Position');
np=[g(1) g(2) g(3) g(4)];
set(g2,'Position',np, 'FontSize', 12);

yyaxis left
histogram(model(:,3),phi_mod,'FaceAlpha',0.3);
title('Phi Middle (°)', 'FontSize', 14);

if max(model(:,1))<=90
    xlim([-90 90]);
elseif max(model(:,1))>90
    xlim([0 180]);
end

ylim([0 scl1]);
yticks([]);

% Best Middle
l=line([phi2 phi2],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;
l=line([20 20],ylim,'Color','r','LineWidth',2);

yyaxis right
histogram(bf(:,3),phi_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
yticks([]);

%set(gca,'FontName','Times');

% Phi Upper

g3=subplot(233);
g=get(g3,'Position');
np=[g(1)-0.05 g(2) g(3) g(4)];
set(g3,'Position',np, 'FontSize', 12);

yyaxis left
histogram(model(:,5),phi_mod,'FaceAlpha',0.3);
title('Phi Upper (°)', 'FontSize', 14);

if max(model(:,1))<=90
    xlim([-90 90]);
elseif max(model(:,1))>90
    xlim([0 180]);
end

ylim([0 scl1]);
yticks([]);

% Best Fit Upper
l=line([phi3 phi3],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;
l=line([100 100],ylim,'Color','r','LineWidth',2);

yyaxis right
histogram(bf(:,5),phi_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
ylabel('Bandfit', 'FontWeight', 'bold');

%set(gca,'FontName','Times');

%% Delay Time

dt1=model(1,2);
dt2=model(1,4);
dt3=mod(1,6);

% Find a nice range for the ylim

z1=histcounts(model(:,2),length(dt_mod));
z2=histcounts(model(:,4),length(dt_mod));
z3=histcounts(model(:,6),length(dt_mod));
z=max([z1 z2 z3]);

scl1=z+1*10^(numel(num2str(z))-1);

% Do the same for bandfit

z1=histcounts(bf(:,2),length(dt_mod));
z2=histcounts(bf(:,4),length(dt_mod));
z3=histcounts(bf(:,6),length(dt_mod));
z=max([z1 z2 z3]);

scl2=z+0.05*10^(numel(num2str(z))-1);

% Dt Lower

g4=subplot(234);
g=get(g4,'Position');
np=[g(1)+0.05 g(2) g(3) g(4)];
set(g4,'Position',np, 'FontSize', 12);

yyaxis left
histogram(model(:,2),dt_mod,'FaceAlpha',0.3);
title('Dt Lower (s)', 'FontSize', 14);
xlim([min(dt_mod) max(dt_mod)]);
ylim([0 scl1]);
ylabel('Robust Models', 'FontWeight', 'bold');

% Best Fit Lower
l=line([dt1 dt1],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;
l=line([0.5 0.5],ylim,'Color','r','LineWidth',2);

yyaxis right
histogram(bf(:,2),dt_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
yticks([]);

%set(gca,'FontName','Times');

% Dt Middle

g5=subplot(235);
g=get(g5,'Position');
np=[g(1) g(2) g(3) g(4)];
set(g5,'Position',np, 'FontSize', 12);

yyaxis left
histogram(model(:,4),dt_mod,'FaceAlpha',0.3);
title('Dt Middle (s)', 'FontSize', 14);
xlim([min(dt_mod) max(dt_mod)]);
ylim([0 scl1]);
yticks([]);

% Best Fit Middle
l=line([dt2 dt2],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;
l=line([2.25 2.25],ylim,'Color','r','LineWidth',2);

yyaxis right
histogram(bf(:,4),dt_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
yticks([]);

%set(gca,'FontName','Times');

% Dt Upper

g6=subplot(236);
g=get(g6,'Position');
np=[g(1)-0.05 g(2) g(3) g(4)];
set(g6,'Position',np, 'FontSize', 12);

yyaxis left
histogram(model(:,6),dt_mod,'FaceAlpha',0.3);
title('Dt Upper (s)', 'FontSize', 14);
xlim([min(dt_mod) max(dt_mod)]);
ylim([0 scl1]);
yticks([]);

% Best Fit Upper
l=line([dt3 dt3],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;
l=line([3.0 3.0],ylim,'Color','r','LineWidth',2);

yyaxis righs
histogram(bf(:,6),dt_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
ylabel('Bandfit', 'FontWeight', 'bold');

%set(gca,'FontName','Times');

sgtitle([num2str(length(model)), ' robust models']);
end
