function [onel] = one_layer(baz,phi,phip,phin,dt,dtp,dtn,phi_mod,dt_mod, mod_dt, mis_sch)

co=1;
phi_mean=mean(phi,'omitnan');
dt_mean=mean(dt,'omitnan');

for i=1:length(phi_mod)
    for j=1:length(dt_mod)
        mod_hor(co,:)=[phi_mod(i) dt_mod(j)];
        co=co+1;
    end
end

onelmisf=0;
onlmisf=zeros(length(mod_hor),1);

for i=1:length(mod_hor)
    for j=1:size(baz,1)
        
        phi1=phi(j);
        dt1=dt(j);
        phi_err = (phip(j) - phin(j)) / 2;
        dt_err = (dtp(j) - dtn(j)) / 2;
        
        if mis_sch == 0
            if mod_dt == 1
                onelmis_tmp = (((phi1-mod_hor(i,1))^2)/(phi_mean^2))+(((dt1-mod_hor(i,2))^2)/(dt_mean^2));
            elseif mod_dt == 0
                onelmis_tmp = (((phi1-mod_hor(i,1))^2)/(phi_mean^2));
            end
        elseif mis_sch == 1
            if mod_dt == 1
                onelmis_tmp = (((phi1-mod_hor(i,1))^2)/(phi_err^2))+(((dt1-mod_hor(i,2))^2)/(dt_err^2));
            elseif mod_dt == 0
                onelmis_tmp = (((phi1-mod_hor(i,1))^2)/(phi_err^2));
            end
        end

        onlmisf(i) = onlmisf(i)+onelmis_tmp;
        
    end
end

[~,ix]=min(onlmisf);
onel=[mod_hor(ix,1) mod_hor(ix,2) onlmisf(ix)];

end

