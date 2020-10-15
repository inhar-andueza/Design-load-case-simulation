function [] = DLC1_4( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vr )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
%% DLC 1.4
Vhub=[Vr-2,Vr,Vr+2];
%For DLC 1.4 the design standard requires six 1-min simulations at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %2.0f ',90); % 1 min = 60 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
%%
fid=fopen(FFWindFile,'rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',2);
fclose(fid);
%%
fid=fopen('IEC.ipt','rt+');
for j=1:7
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%2.0f.',60); %start of the IEC transient condition
fclose(fid);
%%
for i=sp.i:length(Vhub)
    sp.i=i;
    z=10*Vhub(i);
    %%
    cd('Simulating_DLCs\Results\DLC1_4')
    mkdir ECD_N
    mkdir ECD_P
    cd(SimulationDirectory)
    try
        
        ECD(Vhub(i))
        
        cd(SimulationDirectory)
        %%
        iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\ECD_00NR.WND'];
        
        fid=fopen(FFWindFile,'rt+');
        for j=1:15
            fgetl(fid);
        end
        fseek(fid,0,'cof');
        fprintf(fid,'"%s" ',iecfile);
        fclose(fid);
        %%
        system(RunFAST);
        %%
        cd(SimulationDirectory)
        y=['ECD_00NR_',num2str(z),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        movefile(y,'Simulating_DLCs\Results\DLC1_4\ECD_N')
        %%
        iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\ECD_00PR.WND'];
        
        fid=fopen(FFWindFile,'rt+');
        for j=1:15
            fgetl(fid);
        end
        fseek(fid,0,'cof');
        fprintf(fid,'"%s" ',iecfile);
        fclose(fid);
        
        system 'FAST PrimaryFile.fst';
        
        y=['ECD_00PR_',num2str(z),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC1_4\ECD_P';
        movefile(y,x)
    catch ME
    end
    cd(SimulationDirectory)
    
end
sp.i=1;
end