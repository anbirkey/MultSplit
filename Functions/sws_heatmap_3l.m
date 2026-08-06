function sws_heatmap_3l(final_model, phi_mod, dt_mod, n)

    figure;

    set(gcf, 'Units', 'inches', 'Position', [1 1 18 8]);

    % Fast Directions (1 and 2)
    ax1 = subplot(231);

    xvals = final_model(:,1);
    yvals = final_model(:,3);

    step = phi_mod(2) - phi_mod(1);

    freq = zeros(length(phi_mod));

    for k = 1:size(final_model, 1)
        xi = round((xvals(k) - phi_mod(1)) / step) + 1;
        yi = round((yvals(k) - phi_mod(1)) / step) + 1;
        if xi >= 1 && xi <= length(phi_mod) && yi >= 1 && yi <= length(phi_mod)
            freq(yi, xi) = freq(yi, xi) + 1;
        end
    end
 
        freq(freq == 0) = NaN;
    
    h=imagesc(phi_mod, phi_mod, freq); hold on;
    set(h, 'AlphaData', ~isnan(freq));
    set(gca,'FontName','Arial','FontSize',12)
    colormap(ax1,flipud(parula(max(freq(:)))));
    clim(ax1, [0.5 max(freq(:)) + 0.5]);
    xlabel('Lower Fast Direction (°)', 'FontWeight', 'bold');
    ylabel('Middle Fast Direction (°)', 'FontWeight', 'bold');
    axis xy;
    c=colorbar;
    c.Label.String = 'Number of Robust Models';
    c.Label.FontSize = 14;

    maxfreq = max(freq(:));
    if maxfreq <= 10
        tickstep = 1;
    elseif maxfreq <= 20
        tickstep = 2;
    else
        tickstep = 5;
    end

    c.Ticks = 0:tickstep:maxfreq;
    hold on;
    
    plot([final_model(1,1) final_model(1,1)], [min(phi_mod)-1.5 max(phi_mod)+1.5],'r')
    plot([min(phi_mod)-1.5 max(phi_mod)+1.5], [final_model(1,3) final_model(1,3)], 'r')
    scatter(final_model(1:n,1), final_model(1:n,3), 40, 'ro', 'LineWidth', 2);
    
    daspect([step, step, 1]);

    % Fast Directions (2 and 3)
    ax2 = subplot(232);

    xvals = final_model(:,3);
    yvals = final_model(:,5);

    step = phi_mod(2) - phi_mod(1);

    freq = zeros(length(phi_mod));

    for k = 1:size(final_model, 1)
        xi = round((xvals(k) - phi_mod(1)) / step) + 1;
        yi = round((yvals(k) - phi_mod(1)) / step) + 1;
        if xi >= 1 && xi <= length(phi_mod) && yi >= 1 && yi <= length(phi_mod)
            freq(yi, xi) = freq(yi, xi) + 1;
        end
    end
 
    freq(freq == 0) = NaN;
    
    h=imagesc(phi_mod, phi_mod, freq); hold on;
    set(h, 'AlphaData', ~isnan(freq));
    set(gca,'FontName','Arial','FontSize',12)
    colormap(ax2,flipud(parula(max(freq(:)))));
    clim(ax2, [0.5 max(freq(:)) + 0.5]);
    xlabel('Middle Fast Direction (°)', 'FontWeight', 'bold');
    ylabel('Upper Fast Direction (°)', 'FontWeight', 'bold');
    axis xy;
    c=colorbar;
    c.Label.String = 'Number of Robust Models';
    c.Label.FontSize = 14;

    maxfreq = max(freq(:));
    if maxfreq <= 10
        tickstep = 1;
    elseif maxfreq <= 20
        tickstep = 2;
    else
        tickstep = 5;
    end

    c.Ticks = 0:tickstep:maxfreq;
    hold on;
    
    plot([final_model(1,1) final_model(1,1)], [min(phi_mod)-1.5 max(phi_mod)+1.5],'r')
    plot([min(phi_mod)-1.5 max(phi_mod)+1.5], [final_model(1,3) final_model(1,3)], 'r')
    scatter(final_model(1:n,1), final_model(1:n,3), 40, 'ro', 'LineWidth', 2);
    
    daspect([step, step, 1]);
    
    % Fast Directions (1 and 3)
    ax3 = subplot(233);

    xvals = final_model(:,1);
    yvals = final_model(:,5);

    step = phi_mod(2) - phi_mod(1);

    freq = zeros(length(phi_mod));

    for k = 1:size(final_model, 1)
        xi = round((xvals(k) - phi_mod(1)) / step) + 1;
        yi = round((yvals(k) - phi_mod(1)) / step) + 1;
        if xi >= 1 && xi <= length(phi_mod) && yi >= 1 && yi <= length(phi_mod)
            freq(yi, xi) = freq(yi, xi) + 1;
        end
    end
 
    freq(freq == 0) = NaN;
    
    h=imagesc(phi_mod, phi_mod, freq); hold on;
    set(h, 'AlphaData', ~isnan(freq));
    set(gca,'FontName','Arial','FontSize',12)
    colormap(ax3,flipud(parula(max(freq(:)))));
    clim(ax3, [0.5 max(freq(:)) + 0.5]);
    xlabel('Lower Fast Direction (°)', 'FontWeight', 'bold');
    ylabel('Upper Fast Direction (°)', 'FontWeight', 'bold');
    axis xy;
    c=colorbar;
    c.Label.String = 'Number of Robust Models';
    c.Label.FontSize = 14;

    maxfreq = max(freq(:));
    if maxfreq <= 10
        tickstep = 1;
    elseif maxfreq <= 20
        tickstep = 2;
    else
        tickstep = 5;
    end

    c.Ticks = 0:tickstep:maxfreq;
    hold on;
    
    plot([final_model(1,1) final_model(1,1)], [min(phi_mod)-1.5 max(phi_mod)+1.5],'r')
    plot([min(phi_mod)-1.5 max(phi_mod)+1.5], [final_model(1,3) final_model(1,3)], 'r')
    scatter(final_model(1:n,1), final_model(1:n,3), 40, 'ro', 'LineWidth', 2);
    
    daspect([step, step, 1]);

    % Delay Times (1 and 2)
    ax4=subplot(234);
    
    xvals = final_model(:,2);
    yvals = final_model(:,4);
    step = dt_mod(2) - dt_mod(1);
    
    freq = zeros(length(dt_mod));
    
    for k = 1:size(final_model, 1)
        xi = round((xvals(k) - dt_mod(1)) / step) + 1;
        yi = round((yvals(k) - dt_mod(1)) / step) + 1;
        if xi >= 1 && xi <= length(dt_mod) && yi >= 1 && yi <= length(dt_mod)
            freq(yi, xi) = freq(yi, xi) + 1;
        end
    end
    
    freq(freq == 0) = NaN;
    
    h=imagesc(dt_mod, dt_mod, freq);
    set(h, 'AlphaData', ~isnan(freq));
    set(gca,'FontName','Arial','FontSize',12)
    colormap(ax4,flipud(parula(max(freq(:)))));
    clim(ax4, [0.5 max(freq(:)) + 0.5]);
    xlabel('Lower Delay Time (s)', 'FontWeight', 'bold');
    ylabel('Middle Delay Time (s)', 'FontWeight', 'bold');
    axis xy;
    c=colorbar;
    c.Label.String = 'Number of Robust Models';
    c.Label.FontSize = 14;
    c.Ticks = 1:max(freq(:));
    hold on;
    
    plot([final_model(1,2) final_model(1,2)], [min(dt_mod)-1.5 max(dt_mod)+1.5],'r')
    plot([min(dt_mod)-1.5 max(dt_mod)+1.5], [final_model(1,4) final_model(1,4)], 'r')
    scatter(final_model(1:n,2), final_model(1:n,4), 40, 'ro', 'LineWidth', 2);
    
    daspect([step, step, 1]);

    % Delay Times (1 and 2)
    ax5=subplot(235);
    
    xvals = final_model(:,4);
    yvals = final_model(:,6);
    step = dt_mod(2) - dt_mod(1);
    
    freq = zeros(length(dt_mod));
    
    for k = 1:size(final_model, 1)
        xi = round((xvals(k) - dt_mod(1)) / step) + 1;
        yi = round((yvals(k) - dt_mod(1)) / step) + 1;
        if xi >= 1 && xi <= length(dt_mod) && yi >= 1 && yi <= length(dt_mod)
            freq(yi, xi) = freq(yi, xi) + 1;
        end
    end
    
    freq(freq == 0) = NaN;
    
    h=imagesc(dt_mod, dt_mod, freq);
    set(h, 'AlphaData', ~isnan(freq));
    set(gca,'FontName','Arial','FontSize',12)
    colormap(ax5,flipud(parula(max(freq(:)))));
    clim(ax5, [0.5 max(freq(:)) + 0.5]);
    xlabel('Middle Delay Time (s)', 'FontWeight', 'bold');
    ylabel('Upper Delay Time (s)', 'FontWeight', 'bold');
    axis xy;
    c=colorbar;
    c.Label.String = 'Number of Robust Models';
    c.Label.FontSize = 14;
    c.Ticks = 1:max(freq(:));
    hold on;
    
    plot([final_model(1,2) final_model(1,2)], [min(dt_mod)-1.5 max(dt_mod)+1.5],'r')
    plot([min(dt_mod)-1.5 max(dt_mod)+1.5], [final_model(1,4) final_model(1,4)], 'r')
    scatter(final_model(1:n,2), final_model(1:n,4), 40, 'ro', 'LineWidth', 2);
    
    daspect([step, step, 1]);

    % Delay Times (1 and 2)
    ax6=subplot(236);
    
    xvals = final_model(:,2);
    yvals = final_model(:,6);
    step = dt_mod(2) - dt_mod(1);
    
    freq = zeros(length(dt_mod));
    
    for k = 1:size(final_model, 1)
        xi = round((xvals(k) - dt_mod(1)) / step) + 1;
        yi = round((yvals(k) - dt_mod(1)) / step) + 1;
        if xi >= 1 && xi <= length(dt_mod) && yi >= 1 && yi <= length(dt_mod)
            freq(yi, xi) = freq(yi, xi) + 1;
        end
    end
    
    freq(freq == 0) = NaN;
    
    h=imagesc(dt_mod, dt_mod, freq);
    set(h, 'AlphaData', ~isnan(freq));
    set(gca,'FontName','Arial','FontSize',12)
    colormap(ax6,flipud(parula(max(freq(:)))));
    clim(ax6, [0.5 max(freq(:)) + 0.5]);
    xlabel('Lower Delay Time (s)', 'FontWeight', 'bold');
    ylabel('Upper Delay Time (s)', 'FontWeight', 'bold');
    axis xy;
    c=colorbar;
    c.Label.String = 'Number of Robust Models';
    c.Label.FontSize = 14;
    c.Ticks = 1:max(freq(:));
    hold on;
    
    plot([final_model(1,2) final_model(1,2)], [min(dt_mod)-1.5 max(dt_mod)+1.5],'r')
    plot([min(dt_mod)-1.5 max(dt_mod)+1.5], [final_model(1,4) final_model(1,4)], 'r')
    scatter(final_model(1:n,2), final_model(1:n,4), 40, 'ro', 'LineWidth', 2);
    
    daspect([step, step, 1]);

end