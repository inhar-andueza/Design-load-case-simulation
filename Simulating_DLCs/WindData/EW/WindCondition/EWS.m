function [] = EWS( x )
cd('Simulating_DLCs\WindData\EW')

fid=fopen('IEC.ipt','rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%4.2f',x);
fclose(fid);

system IECwind

end

