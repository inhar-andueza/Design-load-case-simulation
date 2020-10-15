function [] = DLC7_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
cd(SimulationDirectory)  
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 7.1
Vhub = Vr;
%For DLC 7.1 the design standard requires six 10-min simulations at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %3.0f ',630); % 10 min = 600 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
%% Change primary.fst to parked condition when one blade feathers accidentally
fid=fopen(SimulationControl,'rt+');
for j=1:6
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',0); % Disable pitch control
for j=1:2
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %2.0f ',90); % Time to start override pitch maneuver for blade 1
for j=1:16
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
yaw=-8:1:8;

for i=sp.i:length(yaw)
    sp.i=i;
    
    fid=fopen(InitialConditions,'rt+');
    for j=1:35
        fgetl(fid);
    end
    fseek(fid,0,'cof');
    fprintf(fid,'          %1.0f ',yaw(i)); % Yaw angle
    fclose(fid);
    
    cd('Simulating_DLCs\Results\DLC7_1')
    mkdir EWM
    cd(SimulationDirectory)
    %%
    for k=sp.k:6
        sp.k=k;
        try 
            EWM01(Vhub,sp.R(k,1))
            cd(SimulationDirectory)
            system(RunFAST);  
        catch ME
        end
        y=['EWM_01_R_',num2str(k),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC7_1\EWM';
        movefile(y,x)
    end
    cd('Simulating_DLCs\Results\DLC7_1')
    a=['EWM_yaw_',num2str(yaw(i))];
    movefile('EWM',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end