function [] = DLC6_4( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 6.4
Vref=50;%Turbine class 1, turbulence characteristic A
Vhub=1:2:(Vref*0.7);
%For DLC 6.4 the –3 design standard requires that six 10-min simulations be run at each wind condition,
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
for i=sp.i:length(Vhub)
    sp.i=i;
    
    cd('Simulating_DLCs\Results\DLC6_4')
    mkdir NTM
    cd(SimulationDirectory)
    for k=sp.k:6
        sp.k=k;
        try
            NTM(Vhub(i),sp.R(k,1))
            
            cd(SimulationDirectory)
            %%
            %------------------------------------------------------------------
            %------------------------------------------------------------------
            % Run FAST for each design load case getting each result in a table
            system(RunFAST);
            %------------------------------------------------------------------
            %------------------------------------------------------------------
            %%
            % Move the output binary file to the results folder each with the name of
            % the corresponding design load case
            y=['NTM_',num2str(k),'.outb'];
            u=PrimaryFile(1:end-4);
            t=[u,'.outb'];
            movefile(t,y)
            x='Simulating_DLCs\Results\DLC6_4\NTM';
            movefile(y,x)
        catch ME
        end
    end
    cd('Simulating_DLCs\Results\DLC6_4')
    a=['NTM_',num2str(fix(Vhub(i)))];
    movefile('NTM',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end