function [] = EDC( x )
% EDC 50-y, the worst situation (worse than EDC 1-y)
cd('Simulating_DLCs\WindData\EW')

fid=fopen('IEC.ipt','rt+');
fseek(fid,0,'cof');
fprintf(fid,'%s','EDC50');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%4.2f',x);
fclose(fid);

system IECwind 

end

