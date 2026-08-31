function [] = hist_plot(mod_final,phi_mod,dt_mod)

%% Make the figure;

f=figure;
f.Units='inches';
f.Position=[0.4 0.4 12 8];

mod_final=sortrows(mod_final,5);

ix=mod_final(:,6)<=min(mod_final(:,6))+4;
bf=mod_final(ix,:);


%% Do the Fast Directions

phi1=mod_final(1,1);
phi2=mod_final(1,3);

% Find a nice range for the ylim

z1 = histcounts(mod_final(:,1), length(phi_mod));
z2 = histcounts(mod_final(:,3), length(phi_mod));
z=max([z1 z2]);

scl1=z+1*10^(numel(num2str(z))-1);

% Do the same thing for the bandfit

z1 = histcounts(bf(:,1), length(phi_mod));
z2 = histcounts(bf(:,3), length(phi_mod));
z=max([z1 z2]);

scl2=z+3*10^(numel(num2str(z))-1); % Scale here needs to be different (fewer mod_finals)

% Phi Lower
g1=subplot(221);
g=get(g1,'Position');
np=[g(1)+0.05 g(2) g(3) g(4)];
set(g1,'Position',np, 'FontSize', 12);

yyaxis left
histogram(mod_final(:,1),phi_mod,'FaceAlpha',0.3);
title('Phi Lower (°)', 'FontName', 'Arial', 'FontSize', 14);
ylabel('Robust models', 'FontName', 'Arial', 'FontWeight', 'bold');

if max(mod_final(:,1))<=90
    xlim([-90 90]);
elseif max(mod_final(:,1))>90
    xlim([0 180]);
end

ylim([0 scl1]);

% Best Fit Lower
l=line([phi1 phi1],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;

yyaxis right
histogram(bf(:,1),phi_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
yticks([]);

%set(gca,'FontName','Times');

% Phi Upper
g2=subplot(222);
g=get(g2,'Position');
np=[g(1)-0.05 g(2) g(3) g(4)];
set(g2,'Position',np, 'FontSize', 12);

yyaxis left
histogram(mod_final(:,3),phi_mod,'FaceAlpha',0.3);
title('Phi Upper (°)', 'FontName', 'Arial', 'FontSize', 14);

if max(mod_final(:,1))<=90
    xlim([-90 90]);
elseif max(mod_final(:,1))>90
    xlim([0 180]);
end

ylim([0 scl1]);
yticks([]);
%set(g2,'YAxisLocation','right');

% Best Fit Upper
l=line([phi2 phi2],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;

yyaxis right
histogram(bf(:,3),phi_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
ylabel('Bandfit', 'FontName', 'Arial', 'FontWeight', 'bold');

%set(gca,'FontName','Times');

%% Delay Time

dt1=mod_final(1,2);
dt2=mod_final(1,4);

% Find a nice range for the ylim

z1 = histcounts(mod_final(:,2), length(dt_mod));
z2 = histcounts(mod_final(:,4), length(dt_mod));

z=max([z1 z2]);

scl1=z+1*10^(numel(num2str(z))-1);

% Do the same thing for the bandfit

z1 = histcounts(bf(:,2), length(dt_mod));
z2 = histcounts(bf(:,4), length(dt_mod));

z=max([z1 z2]);

scl2=z+3*10^(numel(num2str(z))-1); % Scale here needs to be different (fewer mod_finals)

% Dt Lower

g3=subplot(223);
g=get(g3,'Position');
np=[g(1)+0.05 g(2) g(3) g(4)];
set(g3,'Position',np, 'FontSize', 12);

yyaxis left
histogram(mod_final(:,2),dt_mod,'FaceAlpha',0.3);
title('Dt Lower (s)', 'FontName', 'Arial', 'FontSize', 14);
xlim([min(dt_mod) max(dt_mod)]);
ylim([0 scl1]);
ylabel('Robust models', 'FontName', 'Arial', 'FontWeight', 'bold');

% Best Fit Lower
l=line([dt1 dt1],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;

yyaxis right
histogram(bf(:,2),dt_mod,'FaceAlpha',0.3);
yticks([]);
ylim([0 scl2]);

%set(gca,'FontName','Times');

% Dt Upper

g4=subplot(224);
g=get(g4,'Position');
np=[g(1)-0.05 g(2) g(3) g(4)];
set(g4,'Position',np, 'FontSize', 12);

yyaxis left
histogram(mod_final(:,4),dt_mod,'FaceAlpha',0.3);
title('Dt Upper (s)', 'FontName', 'Arial', 'FontSize', 14);
xlim([min(dt_mod) max(dt_mod)]);
ylim([0 scl1]);
yticks([]);

% Best Fit Lower
l=line([dt2 dt2],ylim,'Color',[0 0.4470 0.7410],'LineWidth',2);
l.Color(4)=0.6;

yyaxis right
histogram(bf(:,2),dt_mod,'FaceAlpha',0.3);
ylim([0 scl2]);
ylabel('Bandfit', 'FontName', 'Arial', 'FontWeight', 'bold');

%set(gca,'FontName','Times');

sgtitle([num2str(length(mod_final)), ' Robust models'], 'FontName', 'Arial');

end
