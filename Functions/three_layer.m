function [mod_three] = three_layer(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,freq,mod_dt,mis_sch)

if phi_mod(2)-phi_mod(1)<5
    warning('Small grid spacing will yield a large number of iterations and take a long time! This model will not run');
    mod_three=[];
else
    phi_mean=mean(phi);
    dt_mean=mean(dt);
    phip = abs(mod(phipos - phi + 90, 180) - 90);
    phin = abs(mod(phi - phineg + 90, 180) - 90);
    dtn=abs(dt-dtneg);
    dtp=abs(dt-dtpos);

    for i=1:length(phi)
        if phin(i)>180
            phin(i)=abs(phin(i)-180);
        elseif phip(i)>180
            phip(i)=abs(phip(i)-180);
        end
    end

    [P, D] = ndgrid(phi_mod, dt_mod);
    mod_hor = [P(:) D(:)];

    m1=size(mod_hor,1);
    m2=size(mod_hor,1);
    m3=size(mod_hor,1);

    count1=1;

    %ite=m1*m2*m3*size(baz,1);

    %% Loop through MS_effective_splitting

    tic
    hh=waitbar(0,'progress');
    fontsize(hh,16,'points');
    
    mod_three=zeros(m1*m2*m3,8);

    % Determine which effective splitting function to use
    if max(phi_mod)==180
        split_func = @MS_effective_splitting_mod;
    elseif max(phi_mod)==90
        split_func = @MS_effective_splitting_N_SS;
    end

    for i=1:m1
        for j=1:m2
            for k=1:m3
                tmp_misfit=0;
                misf1=0;

                phi1=mod_hor(i,1);
                dt1=mod_hor(i,2);
                phi2=mod_hor(j,1);
                dt2=mod_hor(j,2);
                phi3=mod_hor(k,1);
                dt3=mod_hor(k,2);

                if phi1 == phi2 || phi2 == phi3 || abs(phi1 - phi2) == 90 || abs(phi2 - phi3) == 90
                    continue
                end

                for l=1:size(baz,1)

                    baz1=baz(l);
                    phiv=[phi1 phi2 phi3];
                    dtv=[dt1 dt2 dt3];
                    
                    % Calculate the effective splitting
                    [tmp_fast,tmp_dt] = split_func(freq, baz1, phiv, dtv);

                    phiobs=phi(l);
                    dtobs=dt(l);
                    phidif=phiobs-tmp_fast;
                    dtdif=dtobs-tmp_dt;

                    phi_tol = phip(l)*(tmp_fast > phiobs) + phin(l)*(tmp_fast <= phiobs);
                    dt_tol  = dtp(l)*(tmp_dt   > dtobs)  + dtn(l)*(tmp_dt   <= dtobs);
                    
                    if mod_dt == 1
                        tmp1 = double(abs(phidif) > phi_tol || abs(dtdif) > dt_tol);
                    elseif mod_dt == 0
                        tmp1 = double(phidif > phi_tol);
                    end


                    if mis_sch == 0
                        if mod_dt == 1
                            misf=(phidif^2/phi_mean^2) + (dtdif^2/dt_mean^2);
                        elseif mod_dt == 0
                            misf = (phidif^2/phi_mean^2);
                        end
                    elseif mis_sch == 1
                        if mod_dt == 1
                            misf=(phidif^2/phi_err^2) + (dtdif^2/dt_err^2);
                        elseif mod_dt == 0
                            misf = (phidif^2/phi_err^2);
                        end
                    end

                    tmp_misfit=tmp_misfit+misf;
                    misf1=misf1+tmp1;

                end

                mod_three(count1,:)=[mod_hor(i,1) mod_hor(i,2) mod_hor(j,1) mod_hor(j,2) mod_hor(k,1) ...
                    mod_hor(k,2) tmp_misfit misf1];

                count1=count1+1;

            end
        end
        % At end of i loop:
        waitbar(i/m1, hh, sprintf('Progress %d%%', round(100*i/m1)));
    end
    
    mod_three = mod_three(~all(mod_three == 0, 2), :);
    mod_three=mod_three(~isnan(mod_three(:,7)),:); % Remomve NaN values, usually occur when phi in two touching layers are the same

    close (hh)
    disp(['Run time is ',num2str(toc/60),' minutes']);

end
end
