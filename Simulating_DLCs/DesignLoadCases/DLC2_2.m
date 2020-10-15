function [] = DLC2_2( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
%% DLC 2.2
% One blade runs away to the zero pitch set, is an example of one of the rare events
Vhub=Vin:2:Vout;
%For DLC 2.2 the –3 design standard requires that twelve 10-min simulations be run at each wind condition,
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %3.0f ',630); % 10 min = 600 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);

%% Change primary.fst to accidental blade feather condition

fid=fopen(SimulationControl,'rt+');
for j=1:8
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %2.0f ',90); % Time to start override pitch maneuver
fgetl(fid);
for j=1:2
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.1f ',90.2); % Time to start override pitch maneuver of the other blades
    fgetl(fid);
end
for j=1:4
    fgetl(fid);
end
for j=1:2
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.0f ',90); % Pitch maximum value 90º // Blade 1 is 0º
    fgetl(fid);
end
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
    
    cd('Simulating_DLCs\Results\DLC2_2')
    mkdir NTM
    cd(SimulationDirectory)
    
    for k=sp.k:12
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
            x='Simulating_DLCs\Results\DLC2_2\NTM';
            movefile(y,x)
        catch ME
        end
    end
    z=Vhub(i);
    cd('Simulating_DLCs\Results\DLC2_2')
    a=['NTM_',num2str(z)];
    movefile('NTM',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end