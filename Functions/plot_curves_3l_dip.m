function [fast,delay]=plot_curves_3l_dip(final_model,top,freq,baz,mod_plot,phi,phipos,phineg,dt,dtpos,dtneg)
% Function to plot curves for a two layer model with a dipping layer

baz_plot=1:360;

tmp_model=final_model(1:top,:);

phi_dip=mod_plot(:,1);
dt_dip=mod_plot(:,2);

phi_hor_1=tmp_model(:,1);
dt_hor_1=tmp_model(:,2);

phi_hor_2=tmp_model(:,3);
dt_hor_2=tmp_model(:,4);

fast=zeros(top,360);
delay=zeros(top,360);


 % Start with the case where phi ranges from 0-180°
if max(phi_hor_1(:))>90

    for i=1:length(phi_hor_1)
        for j=1:360
            
            phiv=[phi_hor_1(i) phi_dip(j) phi_hor_2(i)];
            dtv=[dt_hor_1(i) dt_dip(j) dt_hor_2(i)];

            [tmp_fast,tmp_dt]=MS_effective_splitting_mod(freq,j,phiv,dtv);

            fast(i,j)=tmp_fast;
            delay(i,j)=tmp_dt;
        end
    end
    
    % Plot fast directions (curves from top n models)
    figure; 
    set(gcf, 'Units','inches','Position', [0.4 0.4 10 8]);
    subplot(211);
    set(gca,'FontName','Arial','FontSize',12);
    hold on;
    for i=1:size(fast,1)
        if i==1
            c1=plot(baz_plot,fast(i,:),'Color',[255/255, 85/255, 85/255],'LineWidth',2);
        else
            plot(baz_plot,fast(i,:),'Color',[128/255, 179/255, 255/255, 0.5]);
        end
    end
    
    phipos = mod(phipos - phi + 90, 180) - 90;
    phineg = mod(phi - phineg + 90, 180) - 90;
    errorbar(baz,phi,phineg,phipos,'o','Color','k');
    
    title(['Number of statistically robust models: ',num2str(length(final_model))]);
    xlim([0 360]);
    xticks(0:45:360);
    ylim([0 180]);
    
    ylabel('Fast Direction (°)','FontWeight','bold');

    box on;
    
    % Plot delay times
    subplot(212);
    set(gca,'FontName','Arial','FontSize',12);
    hold on;
    for i=1:size(delay,1)
        if i==1
            plot(baz_plot,delay(i,:),'Color',[255/255, 85/255, 85/255],'LineWidth',2);
        else
            plot(baz_plot,delay(i,:),'Color',[128/255, 179/255, 255/255, 0.5]);
        end
    end
    
    dtneg=dt-dtneg;
    dtpos=dtpos-dt;

    legend(c1,'Lowest Misfit Model');

    errorbar(baz,dt,dtneg,dtpos,'o','Color','k','HandleVisibility', 'off');

    xlim([0 360]);
    xticks(0:45:360);
    ylim([0 4]);

    box on;

    ylabel('Delay Time (s)','FontWeight','bold');
    xlabel('Backazimuth (°)','FontWeight','bold');

end

if max(phi_hor_1(:))<90

    for i=1:length(phi_hor_1)
        for j=1:360
            
            phiv=[phi_hor_1(i) phi_dip(j) phi_hor_2(i)];
            dtv=[dt_hor_1(i) dt_dip(j) dt_hor_2(i)];

            [tmp_fast,tmp_dt]=MS_effective_splitting_mod(freq,j,phiv,dtv);
            
            fast(i,j)=tmp_fast;
            delay(i,j)=tmp_dt;
        end
    end
    
    % Plot fast directions (curves from top n models)
    figure; 
    set(gcf, 'Units','inches','Position', [0.4 0.4 10 8]);
    subplot(211);
    set(gca,'FontName','Arial','FontSize',12);
    hold on;
    for i=1:size(fast,1)
        if i==1
            c1=plot(baz_plot,fast(i,:),'Color',[255/255, 85/255, 85/255],'LineWidth',2);
        else
            plot(baz_plot,fast(i,:),'Color',[128/255, 179/255, 255/255, 0.5]);
        end
    end
    
    phipos = mod(phipos - phi + 90, 180) - 90;
    phineg = mod(phi - phineg + 90, 180) - 90;
    errorbar(baz,phi,phineg,phipos,'o','Color','k');
    
    title(['Number of statistically robust models: ',num2str(length(final_model))]);
    xlim([0 360]);
    xticks(0:45:360);
    ylim([-90 90]);
    
    ylabel('Fast Direction (°)','FontWeight','bold');

    box on;
    
    % Plot delay times
    subplot(212);
    set(gca,'FontName','Arial','FontSize',12);
    hold on;
    for i=1:size(delay,1)
        if i==1
            plot(baz_plot,delay(i,:),'Color',[255/255, 85/255, 85/255],'LineWidth',2);
        else
            plot(baz_plot,delay(i,:),'Color',[128/255, 179/255, 255/255, 0.5]);
        end
    end
    
    dtneg=dt-dtneg;
    dtpos=dtpos-dt;

    legend(c1,'Lowest Misfit Model');

    errorbar(baz,dt,dtneg,dtpos,'o','Color','k','HandleVisibility', 'off');

    xlim([0 360]);
    xticks(0:45:360);
    ylim([0 4]);

    box on;

    ylabel('Delay Time (s)','FontWeight','bold');
    xlabel('Backazimuth (°)','FontWeight','bold');

end

end