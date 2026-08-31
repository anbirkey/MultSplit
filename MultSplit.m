% Control script to run multilayer SWS modeling
% Run this section by section

% Run the setup script for the modeling
% This will read in the Parameters file and add relevant pathing

run('model_setup.m');

%% Start by importing the data

% Use the split_import function, which reads in a standard SplitLab csv
% Outputs backazimuth, fast direction, and delay time
% Nulls are filtered out, BUT not filtered by quality (should do manually)
% Adaptively adjusts phi to match the convention you set in the parameters

[baz,incl,phineg,phi,phipos,dtneg,dt,dtpos] = split_import(fname,phi_mod);

%% Prompt for stereoplot

prompt = 'Would you like to see the stereoplot of splits?';

if stereoplot_dlg(prompt)
    stereo_custom(baz, incl, phi, dt);
else
    fprintf('Skipping stereoplot. \n');
end

%% Now we can do the modeling!

% Start by finding the best-fitting one-layer model
% Needed for the f-test, and is independent of other modeling

prompt = 'Do you want to use delay times for modeling?';

mod_dt = model_dlg(prompt);

prompt = 'Which misfit scheme would you list to use?';

mis_sch = model_misfit_dlg(prompt);

onel = one_layer(baz,phi,phipos,phineg,dt,dtpos,dtneg,phi_mod,dt_mod, mod_dt, mis_sch);

% This bit will execute whichever model setup you chose

switch model
    
    case 'two'
        
        mod_two = two_layer(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,freq, mod_dt,mis_sch);
        
    case 'three'
        
        mod_three = three_layer(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,freq,mod_dt,mis_sch);
    
    case 'dip_2l'

        [modeldip,mod_plot] = dip_setup_new(baz,dip,thk,str,inc);

        mod_dip = two_layer_dip(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,modeldip,freq,mod_dt,mis_sch,dip_stp);

    case 'dip_3l'
        
        [modeldip,mod_plot] = dip_setup_new(baz,dip,thk,str,inc);
        
        mod_dip = three_layer_dip(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,modeldip,freq,mod_dt,mis_sch,dip_stp);
        
    otherwise
        
        warning('Not one of the model options :(');
        
end

%% Perform the F-test
% Will compare misfit from the one-layer solution to other model misfits

switch model
    
    case 'two'
        
        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l_new(onel,mod_two,phi,2,4,0.01);

    case 'dip_2l'

        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l_new(onel,mod_dip,phi,2,2,0.01);
        
    case 'dip_3l'
        
        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l_new(onel,mod_dip,phi,2,4,0.01);
        
    case 'three'
        
        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l_new(onel,mod_three,phi,2,6,0.01);
        
end 

%% Now plot the distribution!

% Histogram of all models statistically better than one layer

if ~isempty(final_model)
    switch model
    
        case 'dip_2l'
    
            hist_plot_2l_dip(final_model,stp);
        
        case {'two','dip_3l'}
            
            hist_plot(final_model, phi_mod,dt_mod);
            
        case 'three'
            hist_plot_hhh(final_model,stp);
    end
end

%% Plot the model curves

top = curve_dlg();
top = eval(top{1});

if ~isempty(final_model)

    switch model
    
        case 'two'
            plot_curves_2l(final_model,top,freq,baz,phi,phipos,phineg,dt,dtpos,dtneg);

        case 'dip_2l'
            plot_curves_2l_dip(final_model,top,freq,baz,mod_plot,phi,phipos,phineg,dt,dtpos,dtneg);

        case 'dip_3l'
            plot_curves_3l_dip(final_model,top,freq,baz,mod_plot,phi,phipos,phineg,dt,dtpos,dtneg);

        case 'three'
            plot_curves_3l(final_model,top,freq,baz,phi,phipos,phineg,dt,dtpos,dtneg);

    end

end

%% Now plot the heatmap

if ~isempty(final_model)
    
    switch model

        case {'two', 'dip_3l'}
            sws_heatmap_2l(final_model, phi_mod, dt_mod, 10);
        case 'dip_2l'
            fprintf('Use univariate distribution for this model. \n')
        case 'three'
            sws_heatmap_3l(final_model, phi_mod, dt_mod, 10);

    end

end
