function [baz,incl,phineg,phi,phipos,dtneg,dt,dtpos] = split_import(filename,model)
% Function to import data from a standard SplitLab output
% This one uses the updated version (Deng et al., 2017)
% Should work for any version tho

% Start by defining the file format
% The updated version of SplitLab includes splitting intensity measurements
% These aren't read in - shouldn't affect anything else
fm='%s%f%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%s%s%s%f%f%f%f%s%*[^\n\r]';

% Open the data file

fid=fopen(filename,'r');

data=textscan(fid,fm,'Delimiter',',','EmptyValue',NaN,'HeaderLines',1,'ReturnOnError',false);

fclose(fid);

% Now find the relevant information
% Only really need the backazimuth, fast direction, and delay time
% Should also pull out the null information to exclude nulls

null=find(contains(data{:,34},'NO') | contains(data{:,34},'No') | contains(data{:,34},'no'));

% Now pull the information and filter out nulls
baz1=data{:,6}; baz=baz1(null);

incl1=data{:,10}; incl=incl1(null);

phineg1=data{:,12};phineg=phineg1(null);
phi1=data{:,13}; phi=phi1(null);
phipos1=data{:,14}; phipos=phipos1(null);

if min(model) >= 0
    ind=find(phineg<0); phineg(ind)=phineg(ind)+180;
    ind=find(phi<0); phi(ind)=phi(ind)+180;
    ind=find(phipos<0); phipos(ind)=phipos(ind)+180;
end

dtneg1=data{:,21}; dtneg=dtneg1(null);
dt1=data{:,22}; dt=dt1(null);
dtpos1=data{:,23};dtpos=dtpos1(null);

end