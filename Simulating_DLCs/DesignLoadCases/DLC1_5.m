function [] = DLC1_5( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
%% DLC 1.5
Vhub=Vin:2:Vout;
%For DLC 1.5 the design standard requires six 1-min simulations at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %2.0f ',90); % 1 min = 60 sec + 30 sec to eliminate start-up transient behaviour
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
fprintf(fid,'%2.0f.',60);
fclose(fid);
%% Vertical Extreme Wind Shear
cd('Simulating_DLCs\WindData\EW')

fid=fopen('IEC.ipt','rt+');
fseek(fid,0,'cof');
fprintf(fid,'%s ','EWSV');
fclose(fid);

cd(SimulationDirectory)

iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EWSV00_R.WND'];

fid=fopen(FFWindFile,'rt+');
for j=1:15
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s" ',iecfile);
fclose(fid);

for i=sp.i:length(Vhub)
    sp.i=i;
    
    z=Vhub(i);
    
    cd('Simulating_DLCs\Results\DLC1_5')
    mkdir EWSV
    cd(SimulationDirectory)
    try
        EWS(Vhub(i))
        
        cd(SimulationDirectory)
        
        system(RunFAST);
        
        y=['EWSV00_',num2str(z),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC1_5\EWSV';
        movefile(y,x)
    catch ME
    end
end
sp.i=1;
%% Horizontal Extreme Wind Shear
cd('Simulating_DLCs\WindData\EW')

fid=fopen('IEC.ipt','rt+');
fseek(fid,0,'cof');
fprintf(fid,'%s ','EWSH');
fclose(fid);

cd(SimulationDirectory)

for i=sp.i:length(Vhub)
    sp.i=i;
    
    z=Vhub(i);
    
    cd('Simulating_DLCs\Results\DLC1_5')
    mkdir EWSH
    cd(SimulationDirectory)
    try
        EWS(Vhub(i))
        
        cd(SimulationDirectory)
        %%
        iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EWSV00_R.WND'];
        
        fid=fopen(FFWindFile,'rt+');
        for j=1:15
            fgetl(fid);
        end
        fseek(fid,0,'cof');
        fprintf(fid,'"%s" ',iecfile);
        fclose(fid);
        
        system(RunFAST);
        
        y=['EWSH00_N_',num2str(z),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC1_5\EWSH';
        movefile(y,x)
        %%
        iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EWSH00PR.WND'];
        
        fid=fopen(FFWindFile,'rt+');
        for j=1:15
            fgetl(fid);
        end
        fseek(fid,0,'cof');
        fprintf(fid,'"%s" ',iecfile);
        fclose(fid);
        
        system(RunFAST);
        
        y=['EWSH00_P_',num2str(z),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC1_5\EWSH';
        movefile(y,x)
    catch ME
    end
end
sp.i=1;
end