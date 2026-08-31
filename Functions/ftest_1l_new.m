function [final_model]=ftest_1l(onel,model,phi,p1,p2,alpha)

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

        y1=(onel(3)-model(i,5))/(p2 - p1); % Numerator of the equation (misfit)

        y2=model(i,5)/vb; % Denominator of the equation (df)

        y=y1/y2; % F test

        p(i)=1-fcdf_custom(y,va,vb); % Determine p value based on df

    elseif p2==2

        y1=(onel(3)-model(i,3))/(p2 - p1);

        y2=model(i,3)/vb;

        y=y1/y2;

        p(i)=1-fcdf_custom(y,va,vb);

    elseif p2==6

        y1=(onel(3)-model(i,7))/(p2 - p1); % Numerator of the equation (misfit)

        y2=model(i,7)/vb; % Denominator of the equation (df)

        y=y1/y2; % F test

        p(i)=1-fcdf_custom(y,va,vb); % Determine p value based on df
    end

end

% DIAGNOSTIC
% Provides some information on the F-test results
if p2==4
    misfit_col = 5;
elseif p2==6
    misfit_col = 7;
elseif p2==2
    misfit_col = 3;
end

[F_min_p, idx] = min(p);
fprintf('\n--- F-test diagnostic ---\n');
fprintf('Single-layer misfit:   %.4f\n', onel(3));
fprintf('Best two-layer misfit: %.4f\n', min(model(:,misfit_col)));
fprintf('Misfit reduction:      %.4f (%.1f%%)\n', ...
    onel(3)-min(model(:,misfit_col)), ...
    100*(onel(3)-min(model(:,misfit_col)))/onel(3));
fprintf('Best F-statistic:      %.4f\n', ...
    ((onel(3)-model(idx,misfit_col))/(p2-p1)) / (model(idx,misfit_col)/vb));
fprintf('Best p-value:          %.4e (alpha=%.3f)\n', F_min_p, alpha);
fprintf('df: va=%d, vb=%d\n', va, vb);
fprintf('-------------------------\n\n');
% END DIAGNOSTIC

x=find(p<=alpha); % Change depending on what the probablity level is set at

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
        F_crit = fzero(@(x) fcdf_custom(x, vb, vb) - (1 - alpha), 1);  % or use 1-alpha
        %F_crit = fzero(@(x) fcdf_custom(x, (p2-p1), vb) - alpha, 1);  % or use 1-alpha

        % Acceptance threshold
        threshold = best_misfit * (1 + (p2/vb) * F_crit);
        %threshold = best_misfit * (1 + sqrt(2/vb));

        % Find all models within threshold
        x2 = find(model_tmp(:,5) <= threshold);
        final_model = model_tmp(x2,:);

    elseif p2==2

        % Find best model misfit
        best_misfit = min(model_tmp(:,3));
        
        % F critical value at your chosen alpha, with df of the best model
        F_crit = fzero(@(x) fcdf_custom(x, vb, vb) - (1-alpha), 1);  % or use 1-alpha
        
        % Acceptance threshold
        threshold = best_misfit * (1 + (p2/vb) * F_crit);
        
        % Find all models within threshold
        x2 = find(model_tmp(:,3) <= threshold);
        final_model = model_tmp(x2,:);

    elseif p2==6

        % Find best model misfit
        best_misfit = min(model_tmp(:,7));
        
        % F critical value at your chosen alpha, with df of the best model
        F_crit = fzero(@(x) fcdf_custom(x, vb, vb) - (1 - alpha), 1);  % or use 1-alpha
        
        % Acceptance threshold
        threshold = best_misfit * (1 + (p2/vb) * F_crit);
        
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
