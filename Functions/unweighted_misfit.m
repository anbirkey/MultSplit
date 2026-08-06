function [misf] = unweighted_misfit(phidif, phi_mean, dtdif, dt_mean, mod_dt)

    if mod_dt == 1
        misf = (phidif^2/phi_mean^2) + (dtdif^2/dt_mean^2);
    elseif mod_dt == 0
        misf = (phidif^2/phi_mean^2);
    end
 
end