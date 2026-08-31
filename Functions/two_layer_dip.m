function [mod_dip] = two_layer_dip(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,modeldip,freq,mod_dt,mis_sch,dip_stp)

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

%% Set up the model space

co=1;

mod_hor = zeros(length(phi_mod)*length(dt_mod),2);

for i=1:length(phi_mod)
    for j=1:length(dt_mod)
        mod_hor(co,:)=[phi_mod(i) dt_mod(j)];
        co = co+1;
    end
end

m1=size(modeldip,1);
m2=size(mod_hor,1);
m3=size(baz,1);

count1=1;

%% Now do the modeling

tic
hh=waitbar(0,'progress');
fontsize(hh,16,'points');

mod_dip = zeros(m1*m2, 4);

% Determine which effective splitting function to use
if max(phi_mod)==180
    split_func = @MS_effective_splitting_SS_vec_mod;
elseif max(phi_mod)==90
    split_func = @MS_effective_splitting_SS_vec;
end

for i=1:m1
    for j=1:m2
        tmp_misfit=0;
        misf1=0;
        
        for k=1:m3
        
        baz1=baz(k);
        phi1=modeldip(i,1);
        dt1=modeldip(i,2);
        phi2=mod_hor(j,1);
        dt2=mod_hor(j,2);
        
        if strcmpi(dip_stp, 'HD')
            phiv=[phi1 phi2];
            dtv=[dt1 dt2];
        elseif strcmpi(dip_stp, 'DH')
            phiv=[phi2 phi1];
            dtv=[dt2 dt1];
        end
        
        % Calculate the effective splitting
        [tmp_fast,tmp_dt] = split_func(freq, baz1, phiv, dtv);
        
        phiobs=phi(k);
        dtobs=dt(k);
        
        phidif=abs(phiobs-tmp_fast);
        dtdif=abs(dtobs-tmp_dt);

        phi_tol = phip(k) * (tmp_fast > phiobs) + phin(k) * (tmp_fast <= phiobs);
        dt_tol  = dtp(k)  * (tmp_dt   > dtobs)  + dtn(k)  * (tmp_dt   <= dtobs);
        
        if mod_dt == 1

            tmp1 = double(phidif > phi_tol || dtdif > dt_tol);
        
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
        
        mod_dip(count1,:) = [mod_hor(j,1) mod_hor(j,2) tmp_misfit misf1];
        
        count1=count1+1;
    end

    waitbar(i/m1, hh, sprintf('Progress %d%%', round(100*i/m1)));
    
end

mod_dip=mod_dip(~isnan(mod_dip(:,3)),:); % Remove NaN values, usually occurs when phi1 and phi2 are 180° apart
close(hh)

disp(['Run time is ',num2str(toc/60),' minutes']);

end
