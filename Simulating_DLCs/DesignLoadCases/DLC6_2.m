function [] = DLC6_2( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
cd(SimulationDirectory)  
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 6.2
Vhub = Vr;
%For DLC 6.2 the design standard requires six 1-h simulations at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %3.0f ',630); % 10 min = 600 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);              
%% Change primary.fst to parked condition
fid=fopen(SimulationControl,'rt+');
for j=1:6
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',0); % Disable pitch control
for j=1:18
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'     %4.1f ',9999.9); % Time to start the generator
fclose(fid);
%%
fid=fopen(InitialConditions,'rt+');
for j=1:29
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.0f ',90); % Blade pitch 90º
    fgetl(fid);
end
for j=1:2
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %1.1f ',0.1); % Initial rotor speed
fgetl(fid);
fclose(fid);
%%
turbsimfile = [SimulationDirectory,'\Simulating_DLCs\WindData\TW\TurbSim'];

fid=fopen(FFWindFile,'rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',4);
for j=1:17
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s" ',turbsimfile);
fclose(fid);
%%
yaw=-180:20:180;
yaw(1,1)=-179;

for i=sp.i:length(yaw)
    sp.i=i;
    
    fid=fopen(InitialConditions,'rt+');
    for j=1:35
        fgetl(fid);
    end
    fseek(fid,0,'cof');
    fprintf(fid,'          %1.0f ',yaw(i)); % Yaw angle
    fclose(fid);
    
    cd('Simulating_DLCs\Results\DLC6_2')
    mkdir EWM
    cd(SimulationDirectory)
    %%
    for k=sp.k:6
        sp.k=k;
        try
            EWM50(Vhub,sp.R(k,1))
            cd(SimulationDirectory)
            system(RunFAST);
        catch ME
        end

        y=['EWM_50_R_',num2str(k),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC6_2\EWM';
        movefile(y,x)
    end
    cd('Simulating_DLCs\Results\DLC6_2')
    a=['EWM_yaw_',num2str(yaw(i))];
    movefile('EWM',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end