function [modeldip,mod_plot] = dip_setup(baz,dipv,h,str,inc)

%% Set up some things

rhov=3.345;
rakv=0;
h1=h/cos(deg2rad(dipv));
H=h1/cos(deg2rad(inc));

Xrot=rakv; Zrot=dipv; Yrot=-1*str;

% Stiffness tensor from Chevrot and van der Hilst (2003)
% Mixture of average stiffness tensor for olivine from Kumazawa and
% Anderson (1968) with an isotropic reference mantle

cij4 = [212800000000 79160000000  76240000000  0           0           0;...
        79160000000  212800000000 76240000000  0           0           0;...
        76240000000  76240000000  249180000000 0           0           0;...
        0            0            0            70470000000 0           0;...
        0            0            0            0           70470000000 0;...
        0            0            0            0           0           66720000000];
    
%% Do some basic rotation

[RHex]=MS_rotM(0,90,0);
[cij2]=MS_rotR(cij4,RHex);

[cij3]=MS_rot3(cij2,Xrot,Zrot,Yrot);

%% Run the loop

cou1=1;

for i=1:size(baz,1)
    kx=sin(inc*pi/180)*cos(baz(i)*pi/180); ky=sin(inc*pi/180)*sin(baz(i)*pi/180); kz=cos(inc*pi/180);
    
    D = [kx 0 0 0 kz ky; 0 ky 0 kz 0 kx; 0 0 kz ky kx 0]/sqrt(kx^2+ky^2+kz^2);
    [E,Ch] = eig(D*cij3*D');
    V = sqrt(Ch/rhov/1000)/1000;			 
    [vel,k] = sort(diag(V),'descend');
    
      if (vel(2) > vel(3))

      % fpol is the fast direction (be careful with these results as matlab uses unit circle coordinates)			 
      % fpol must first be converted to cartesian degrees (basically 90 - fpol)
			 
        fpol = atan2(E(2,k(2)),E(1,k(2)))*180/pi;
        spol= atan2(E(2,k(3)),E(1,k(3)))*180/pi;
        dt = H*(vel(2)-vel(3))/vel(2)/vel(3);  
        fbaz(cou1,1) = baz(i);
        apphi1(cou1,1) = fpol;
        apdt(cou1,1) = dt;
        cou1 = cou1 + 1;
      end
end

%% Some final bits and bobs

apphi=MS_unwind_pm_90(apphi1);

modeldip=[apphi apdt fbaz];


%% Do the same thing for all backazimuths

cou2=1;

for m1=1:360
    kxm=sin(inc*pi/180)*cos(m1*pi/180); kym=sin(inc*pi/180)*sin(m1*pi/180); kzm=cos(inc*pi/180);
    
    Dm=[kxm 0 0 0 kzm kym; 0 kym 0 kzm 0 kxm; 0 0 kzm kym kxm 0]/sqrt(kxm^2+kym^2+kzm^2);
    [Em,Chm]=eig(Dm*cij3*Dm');
    Vm=sqrt(Chm/rhov/1000)/1000;
    [velm,km]=sort(diag(Vm),'descend');
    
    if velm(2) > velm(3)
        fpol=atan2(Em(2,km(2)),Em(1,km(2)))*180/pi;
        spol=atan2(Em(2,km(3)),Em(1,km(3)))*180/pi;
        dt=H*(velm(2)-velm(3))/velm(2)/velm(3);
        fbazm(cou2,1)=m1;
        apphim(cou2,1)=fpol;
        apdtm(cou2,1)=dt;
        cou2=cou2+1;
        
    end
end

mapphi=MS_unwind_pm_90(apphim);
mod_plot=[mapphi apdtm fbazm];

save('mod.mat','modeldip','mod_plot');

end