function [] = NWP( x )
%% Normal Wind Profile
cd('Simulating_DLCs\WindData\EW')

x=char(string(x));
ini=['    0.000	   ',x,'	    0.000	    0.000	    0.000	    0.200	    0.000	    0.000'];
fin=['  630.000	   ',x,'	    0.000	    0.000	    0.000	    0.200	    0.000	    0.000'];
%%
fid=fopen('NWP.WND','w');
fseek(fid,0,'bof');
fprintf(fid,'%s\n',ini);
fprintf(fid,'%s',fin);
fclose(fid);
end

