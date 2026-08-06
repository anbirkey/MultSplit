function [modeldip, mod_plot] = dip_setup_new(baz, dip, h, str, aoi)

%% Set up some basics

faln = 0.3; % Probably a reasonable value, but makes a big difference

% Convert from angle of incidence to inclination angle
inc = 90 - aoi;

% Load the anisotropic elastic tensor
[Cani,rh] = MS_elasticDB('olivine');

% Decompose Cani
[Ciso] = MS_decomp(MS_axes(Cani));

% Perform the first rotation 
% Makes the a-axis horizontal
[Cani] = MS_rot3(Cani,90,0,0);

%% Calculate the fast direction and delay time for model baz

% Calculate the distance in the dipping layer

fast = zeros(length(baz), 1);
dt = zeros(length(baz), 1);

for i = 1:length(baz)
    dist = distance_in_dipping_layer(dip,str,aoi,h,baz(i));

    [l_c,~]=MS_VRH([faln 1-faln], MS_rot3(Cani,0,-dip,str,'order',[3 2 1]),rh, Ciso, rh);

    [pol, ~, vs1, vs2, ~, ~, ~] = MS_phasevels(l_c, rh, inc, baz(i));

    % Get the delay times and fast directions
    fast(i) = MS_unwind_pm_90((baz(i)+pol'));

    dt(i) = dist/vs2' - dist/vs1';

end

modeldip = [fast dt baz];

%% Now repeat the same process for all backazimuths (for plotting)

bazi = (1:360)';

fast = zeros(length(bazi), 1);
dt = zeros(length(bazi), 1);

for i = 1:length(bazi)
    dist = distance_in_dipping_layer(dip,str,aoi,h,bazi(i));

    [l_c,~]=MS_VRH([faln 1-faln], MS_rot3(Cani,0,-dip,str,'order',[3 2 1]),rh, Ciso, rh);

    [pol, ~, vs1, vs2, ~, ~, ~] = MS_phasevels(l_c, rh, inc, bazi(i));

    % Get the delay times and fast directions
    fast(i) = MS_unwind_pm_90((bazi(i)+pol'));

    dt(i) = dist/vs2' - dist/vs1';

end

mod_plot = [fast dt bazi];

%% Helper function to calculate distances
function [dist] = distance_in_dipping_layer(dip, aaz, aoi, thick, azi)
    
    % Ray direction vector (1=North, 2=East, 3=Down)
    r = [cosd(azi) .* sind(aoi); ...   % North
         sind(azi) .* sind(aoi); ...   % East
         cosd(aoi) .* ones(size(azi))]; % Down
    
    % Layer normal vector
    % Normal = vertical component + horizontal component from dip
    n = [-sind(dip) .* cosd(aaz); ...  % North
         -sind(dip) .* sind(aaz); ...  % East
          cosd(dip)];                   % Down
    
    % Path length = thick / |r · n|
    % Dot product of ray with layer normal
    dot_rn = r(1,:) .* n(1) + r(2,:) .* n(2) + r(3,:) .* n(3);
    dist = thick ./ abs(dot_rn);
    
end
end