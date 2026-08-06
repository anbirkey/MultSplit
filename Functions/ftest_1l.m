function [final_model]=ftest_1l(onel,model,phi,p1,p2)

% Function to test layered models against one layer

% Uses F-test from Statistics for Engineering and the Sciences by
% Mendenhall and Sincich (2016)

%% Run the F test

% Start by determining the degrees of freedom
% df = data points - parameters tested
% 2 for the single layer, 4 for two layer or HDH, and 6 for HHH

va=2*size(phi,1)-p1;
vb=2*size(phi,1)-p2;

% Run the F test for all the models

for i=1:size(model,1)

    if p2==4

        y1=(onel(3)-model(i,5))/model(i,5); % Numerator of the equation (misfit)

        y2=(va-vb)/vb; % Denominator of the equation (df)

        y=y1/y2; % F test

        p(i)=1-fcdf_custom(y,va,vb); % Determine p value based on df

    elseif p2==2

        y1=(onel(3)-model(i,3))/model(i,3);

        y2=(va-vb)/vb;

        y=y1/y2;

        p(i)=1-fcdf_custom(y,va,vb);

    elseif p2==6

        y1=(onel(3)-model(i,7))/model(i,7); % Numerator of the equation (misfit)

        y2=(va-vb)/vb; % Denominator of the equation (df)

        y=y1/y2; % F test

        p(i)=1-fcdf_custom(y,va,vb); % Determine p value based on df
    end

end

x=find(p<=0.05); % Change depending on what the probablity level is set at

y=length(x)/size(model,1); % Find percentage of models that are better than one layer

if isempty(x)
    disp(' ');
    disp('Sorry, no models better than the single layer solution :(');
    disp(' ');
    final_model = [];
    return;
else

    disp(' ');
    disp('Congratulations! Found models better than the single layer solution');
    disp([num2str(y*100), '% of models are better than the single layer solution']);
    disp(' ');
end

model_tmp=model(x,:); % Isolate statistically better models

% Now run the same test to look for models statistically indistinguishable
% from best model

for i=1:size(model_tmp,1)

    if p2==4

        % Find best model misfit
        best_misfit = min(model_tmp(:,5));
        
        % F critical value at your chosen alpha, with df of the best model
        F_crit = fzero(@(x) fcdf_custom(x, vb, vb) - 0.95, 1);  % or use 1-alpha
        
        % Acceptance threshold
        threshold = best_misfit * (1 + (1/vb) * F_crit);
        
        % Find all models within threshold
        x2 = find(model_tmp(:,5) <= threshold);
        final_model = model_tmp(x2,:);

    elseif p2==2

        % Find best model misfit
        best_misfit = min(model_tmp(:,3));
        
        % F critical value at your chosen alpha, with df of the best model
        F_crit = fzero(@(x) fcdf_custom(x, vb, vb) - 0.95, 1);  % or use 1-alpha
        
        % Acceptance threshold
        threshold = best_misfit * (1 + (1/vb) * F_crit);
        
        % Find all models within threshold
        x2 = find(model_tmp(:,3) <= threshold);
        final_model = model_tmp(x2,:);

    elseif p2==6

        % Find best model misfit
        best_misfit = min(model_tmp(:,7));
        
        % F critical value at your chosen alpha, with df of the best model
        F_crit = fzero(@(x) fcdf_custom(x, vb, vb) - 0.95, 1);  % or use 1-alpha
        
        % Acceptance threshold
        threshold = best_misfit * (1 + (1/vb) * F_crit);
        
        % Find all models within threshold
        x2 = find(model_tmp(:,7) <= threshold);
        final_model = model_tmp(x2,:);
    end

end

disp([num2str(size(final_model, 1)), ' statistically robust models']);

% Sort the final models so that the lowest misfit is first
% Useful for plotting

if p2==4
    final_model=sortrows(final_model,5);
elseif p2==6
    final_model=sortrows(final_model,7);
end