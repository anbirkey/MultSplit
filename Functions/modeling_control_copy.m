% Control script to run multilayer SWS modeling
% Run this section by section

% Run the setup script for the modeling
% This will read in the Parameters file and add relevant pathing

run('model_setup.m');

%% Start by importing the data

% Use the split_import function, which reads in a standard SplitLab csv
% Outputs backazimuth, fast direction, and delay time
% Nulls are filtered out, BUT not filtered by quality (should do manually)

[baz,phineg,phi,phipos,dtneg,dt,dtpos] = split_import(fname);

%% Now we can do the modeling!

% Start by finding the best-fitting one-layer model
% Needed for the f-test, and is independent of other modeling


onel = one_layer(baz,phi,dt,phi_mod,dt_mod);


% This bit will execute whichever model setup you chose

switch mod
    
    case 'two'
        
        mod_two = two_layer(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,freq);
        
    case 'three'
        
        mod_three = three_layer(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,freq);
    
    case 'dip_2l'

        [modeldip,mod_plot] = dip_setup(baz,dip,thk,str,inc);

        mod_dip = two_layer_dip(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,modeldip,freq);

    case 'dip_3l'
        
        [modeldip,mod_plot] = dip_setup(baz,dip,thk,str,inc);
        
        mod_dip = three_layer_dip(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,modeldip,freq);
        
    otherwise
        
        warning('Not one of the model options :(');
        
end

%% Perform the F-test

% Will compare misfit from the one-layer solution to other model misfits
% Be careful, all the outputs have the same name. Save accordingly

switch mod
    
    case 'two'
        
        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l(onel,mod_two,phi,2,4);

    case 'dip_2l'

        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l(onel,mod_dip,phi,2,2);
        
    case 'dip_3l'
        
        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l(onel,mod_dip,phi,2,4);
        
    case 'three'
        
        % One-layer solution, model to test, fast directions, parameters
        final_model = ftest_1l(onel,mod_three,phi,2,6);
        
end 

%% Now plot the distribution!

% Histogram of all models statistically better than one layer

if ~isempty(final_model)
    switch mod
    
        case 'dip_2l'
    
            hist_plot_2l_dip(final_model,stp);
        
        case {'two','dip_3l'}
            
            hist_plot(final_model,stp);
            
        case 'three'
            hist_plot_hhh(final_model,stp);
    end
end

%% Plot the model curves

if ~isempty(final_model)

    switch mod
    
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