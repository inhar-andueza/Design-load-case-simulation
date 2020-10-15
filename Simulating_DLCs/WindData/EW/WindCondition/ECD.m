function [] = ECD(x)
%%
cd('Simulating_DLCs\WindData\EW')

fid=fopen('IEC.ipt','rt+');
fseek(fid,0,'cof');
fprintf(fid,'%s','ECD  ');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%4.2f',x);
for j=1:3
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%2.0f.',60);
fclose(fid);

system IECwind
    
end