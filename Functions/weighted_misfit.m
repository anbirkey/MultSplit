function [misf] = weighted_misfit(phidif, phi_err, dtdif, dt_err, mod_dt)

    if mod_dt == 1
        misf=(phidif^2/phi_err^2) + (dtdif^2/dt_err^2);
    elseif mod_dt == 0
        misf = (phidif^2/phi_err^2);
    end

end