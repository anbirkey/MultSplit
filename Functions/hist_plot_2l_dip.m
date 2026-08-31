function [] = hist_plot_2l_dip(model,phi_mod,dt_mod)

%% Make the figure

f=figure;
f.Units='inches';
f.Position=[0.4 0.4 12 8];

model=sortrows(model,3);

ix=model(:,4)<=min(model(:,4))+4;
bf=model(ix,:);

%% Do the fast directions

phi1=model(1,1);

% Find a nice range for the ylim

z1=histcounts(model(:,1),length(phi_mod));
z=max(z1);

scl1=z+1*10^(numel(num2str(z))-1);

%% Do the same thing for the bandfit

z1=histcounts(bf(:,1),length(phi_mod));
z=max(z1);

scl2=z+3*10^(numel(num2str(z))-1); % Fewer models, so scale needs to be different

% Phi Upper

g1=subplot(211);

yyaxis left
histogram(model(:,1),phi_mod,'FaceAlpha',0.3);
title('Phi Upper (°)', 'FontSize', 14);

if max(model(:,1))<=90
    xlim([-90 90]);
elseif max(model(:,1))>90
    xlim([0 180]);
end

ylim([0 scl1]);
ylabel('Robust Models', 'FontWeight', 'bold');

% Best Fit Upper
l=line([phi1 phi1],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;

yyaxis right
histogram(bf(:,1),phi_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
ylabel('Bandfit', 'FontWeight', 'bold');

set(gca,'FontName','Arial','FontSize',12);

%% Delay Time

dt1=model(1,2);

% Find a nice range for the ylim

z1=histcounts(model(:,2),length(dt_mod));
z=max(z1);

scl1=z+1*10^(numel(num2str(z))-1);

% Do the same for the bandfit

z1=histcounts(bf(:,2),length(dt_mod));
z=max(z1);

scl2=z+3*10^(numel(num2str(z))-1); % Fewer models, so scale needs to be different

% Dt Upper

g2=subplot(212);

yyaxis left
histogram(model(:,2),dt_mod,'FaceAlpha',0.3);
title('Dt Upper (s)', 'FontSize', 14);
xlim([0.4 3]);
ylim([0 scl1]);
ylabel('Robust Models', 'FontWeight', 'bold');

% Best Fit Upper
l=line([dt1 dt1],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;

yyaxis right
histogram(bf(:,2),dt_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
ylabel('Bandfit', 'FontWeight', 'bold');

set(gca,'FontName','Arial','FontSize',12);

sgtitle([num2str(length(model)), ' Robust models']);
end
