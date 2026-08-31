function [mod_two] = two_layer(baz,phineg,phi,phipos,dtneg,dt,dtpos,phi_mod,dt_mod,freq, mod_dt, mis_sch)

phi_mean=mean(phi);
%phi_mean = size(phi, 1);
dt_mean=mean(dt);
%dt_mean = size(dt, 1);
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

m1=size(mod_hor,1);
m2=size(mod_hor,1);
m3=size(baz,1);

%ite=m1*m2*m3;

count1=1;

%% Now do the modeling

tic
hh=waitbar(0,'progress');
fontsize(hh,16,"points");

mod_two = zeros(m1*m2,6);

% Determine which effective splitting function to use
if max(phi_mod)==180
    split_func = @MS_effective_splitting_SS_vec_mod;
elseif max(phi_mod)==90
    split_func = @MS_effective_splitting_SS_vec;
end

% if mis_sch == 1
%     mis_func = @weighted_misfit;
% elseif mis_sch == 0
%     mis_func = @unweighted_misfit;
% end

for i=1:m1
    for j=1:m2
        tmp_misfit=0;
        tmp1=0;
        misf1=0;
        
        phi1=mod_hor(i,1);
        dt1=mod_hor(i,2);
        phi2=mod_hor(j,1);
        dt2=mod_hor(j,2);
        
        if phi1 == phi2 || abs(phi1-phi2) == 90
            continue
        end
    
        for k=1:m3
        
            baz1=baz(k);
            phiv=[phi1 phi2];
            dtv=[dt1 dt2];
    
            % Allows for either fast direction setup
            % if max(phi_mod)==180
            %     [tmp_fast,tmp_dt]=MS_effective_splitting_mod(freq,baz1,phiv,dtv);
            % elseif max(phi_mod)==90
            %     [tmp_fast,tmp_dt]=MS_effective_splitting_N(freq,baz1,phiv,dtv);
            % end
    
            % Calculate the effective splitting
            [tmp_fast,tmp_dt] = split_func(freq, baz1, phiv, dtv);
            
            if tmp_fast > max(phi_mod)
                tmp_fast = tmp_fast - 180;
            elseif tmp_fast < min(phi_mod)
                tmp_fast = tmp_fast + 180;
            end

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
            
            % if j==m2 && k==m3
            %     val=i*j*k;
            %     pers=round(100*val/ite);
            %     waitbar(val/ite,hh,sprintf('Progress %d%%',pers))
            % end
            
            phi_err = (phipos(k) - phineg(k)) / 2;
            dt_err = (dtpos(k) - dtneg(k)) / 2;
            
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
        
        mod_two(count1,:) = [mod_hor(i,1) mod_hor(i,2) mod_hor(j,1) mod_hor(j,2) tmp_misfit misf1];
        
        count1=count1+1;
    end

    waitbar(i/m1, hh, sprintf('Progress %d%%', round(100*i/m1)));
    
end

mod_two = mod_two(~all(mod_two == 0, 2), :);
mod_two=mod_two(~isnan(mod_two(:,5)),:); % Remove NaN values, usually occurs when phi1 and phi2 are 180° apart
close(hh)

disp(['Run time is ',num2str(toc/60),' minutes']);

end
         
        
