function [] = NTM( x,R )
% Normal Turbulence Model wind data
%%   Vin < Vhub < Vout (2 m/s)
cd('Simulating_DLCs\WindData\TW')

fid=fopen('TurbSim.inp','rt+');
for j=1:3
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%10f',R);
for j=1:26
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s"   ','IECKAI');
for j=1:3
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s"   ','NTM');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%2.1f   ',x);
fclose(fid);

system 'TurbSim TurbSim.inp';

end

