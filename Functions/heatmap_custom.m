n = 10;

top_models = final_model(1:n,:);

figure;

set(gcf, 'Units', 'inches', 'Position', [1 1 18 8]);

% Fast Directions
ax1=subplot(121);

xvals = final_model(:,1);
yvals = final_model(:,3);
step = phi_mod(2) - phi_mod(1);

freq = zeros(length(phi_mod));

for k = 1:size(final_model, 1)
    xi = round((xvals(k) - phi_mod(1)) / step) +1;
    yi = round((yvals(k) - phi_mod(1)) / step) +1;
    if xi >= 1 && xi <= length(phi_mod) && yi >= 1 && yi <= length(phi_mod)
        freq(yi, xi) = freq(yi, xi) + 1;
    end
end

freq(freq == 0) = NaN;

h=imagesc(phi_mod, phi_mod, freq); hold on;
set(h, 'AlphaData', ~isnan(freq));
colormap(ax1,flipud(parula(max(freq(:)))));
plot([-91.5 91.5], [final_model(1,3) final_model(1,3)], 'r');
plot([final_model(1,1) final_model(1,1)], [-91.5 91.5], 'r');
xlabel('Lower Fast Direction (°)', 'FontSize', 16);
ylabel('Upper Fast Direction (°)', 'FontSize', 16);
axis xy;
c=colorbar;
c.Label.String = 'Number of Robust Models';
c.Label.FontSize = 16;

scatter(final_model(1:n,1), final_model(1:n,3), 40, 'ro', 'LineWidth', 2);

daspect([step, step, 1]);

% Delay Times
ax2=subplot(122);

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
colormap(ax2,flipud(parula(max(freq(:)))));
xlabel('Lower Delay Time (s)', 'FontSize', 16);
ylabel('Upper Delay Time (s)', 'FontSize', 16);
axis xy;
c=colorbar;
c.Label.String = 'Number of Robust Models';
c.Label.FontSize = 16;
hold on;

scatter(final_model(1:n,2), final_model(1:n,4), 40, 'ro', 'LineWidth', 2);

daspect([step, step, 1]);

%%
figure;

xvals = final_model(:,3);
yvals = final_model(:,2);
step_x = phi_mod(2) - phi_mod(1);
step_y = dt_mod(2) - dt_mod(1);

freq = zeros(length(dt_mod), length(phi_mod));

for k = 1:size(final_model, 1)
    xi = round((xvals(k) - phi_mod(1)) / step_x) + 1;
    yi = round((yvals(k) - dt_mod(1)) / step_y) + 1;
    if xi >= 1 && xi <= length(phi_mod) && yi >= 1 && yi <= length(dt_mod)
        freq(yi, xi) = freq(yi, xi) + 1;
    end
end

freq(freq == 0) = NaN;

h=imagesc(phi_mod, dt_mod, freq);
set(h, 'AlphaData', ~isnan(freq));
%colormap(ax2,flipud(parula(max(freq(:)))));
xlabel('Lower Delay Time (s)', 'FontSize', 16);
ylabel('Upper Delay Time (s)', 'FontSize', 16);
%axis xy;
c=colorbar;
c.Label.String = 'Number of Robust Models';
c.Label.FontSize = 16;
hold on;

scatter(final_model(1:n,3), final_model(1:n,2), 40, 'ro', 'LineWidth', 2);

%daspect([step, step, 1]);
   

