function stereo_custom(baz, inc, phi, dt)
    %% Replica stereoplot
    
    theta = linspace(0, 2*pi, 100);
    incl = [15, 10, 5]; % Need to be in reverse order for the fill function
    bazi = [0, 30, 60, 90, 120, 150];
    x0 = 0;
    y0 = 0;
    
    figure; hold on;
    f = gcf; % Get current figure handle
    f.Position(3:4) = [800 600]; % Set width and height
    
    axis equal;
    axis off;
    xlim([-20, 20]);
    ylim([-20, 20]);
    
    for i = 1:length(incl)
    
        x1 = incl(i)*cos(theta) + x0;
        y1 = incl(i)*sin(theta) + y0;
        
        if i==1
            fill(x1,y1,'w');
        end
        
        plot(x1, y1,'Color',[0 0 0 0.3],'LineWidth',0.7)
    
    end
    
    fill(x1,y1,'w');
    
    for i = 1:length(bazi)
        
        L = 15;
    
        % Calculate endpoint
        x1 = x0 + L * cosd(bazi(i));
        y1 = y0 + L * sind(bazi(i));
        
        plot([-x1 x1], [-y1 y1], 'Color',[0 0 0 0.3],'LineWidth',0.7);
    
    end
    
    text(0, 15.8,'0°','HorizontalAlignment','center');
    text(15.5, 0, '90°','HorizontalAlignment','left');
    text(0, -15.5, '180°','HorizontalAlignment','center');
    text(-15.8, 0, '270°','HorizontalAlignment','right');
    text(4, 0.5, '5°');
    text(8.6, 0.5, '10°');
    text(13.6, 0.5, '15°');
    
    % Now plot the splits
    
    for i = 1:length(baz)
    
        x0 = inc(i) * cos((90-baz(i))*(pi/180));
        y0 = inc(i) * sin((90-baz(i))*(pi/180));
    
        xone = x0 - 2*dt(i) * cos( (90-phi(i)) * (pi/180))/2.0;
        xtwo = x0 + 2*dt(i) * cos( (90-phi(i)) * (pi/180))/2.0;
        yone = y0 - 2*dt(i) * sin( (90-phi(i)) * (pi/180))/2.0;
        ytwo = y0 + 2*dt(i) * sin( (90-phi(i)) * (pi/180))/2.0;
    
        plot([xone, xtwo], [yone,ytwo],'b','LineWidth',1.5);
    
    end
end

