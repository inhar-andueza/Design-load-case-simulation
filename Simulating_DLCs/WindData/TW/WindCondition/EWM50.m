function [] = EWM50(x,R)
% Turbulent Extreme Wind Model
%% 50 year recurrence
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
fprintf(fid,'"%s"  ','1EWM50');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%2.1f   ',x);
fclose(fid);
%% Run TurbSim to get the turbulent wind profiles
cd('Simulating_DLCs\WindData\TW')

system 'TurbSim TurbSim.inp';

end