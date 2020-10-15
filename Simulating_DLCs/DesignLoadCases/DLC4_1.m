function [] = DLC4_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 4.1
Vhub=Vin:2:Vout;
%For DLC 4.1 the –3 design standard requires that six 10-min simulations be run at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %3.0f ',630); % 10 min = 600 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
%% Change primary.fst to normal pitch to feather shutdown
fid=fopen(SimulationControl,'rt+');
for j=1:8
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'        %2.0f ',60); % Time to start override pitch maneuver
    fgetl(fid);
end
for j=1:3
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'        %2.0f ',90); % Feather pitch angle
    fgetl(fid);
end
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%s','False'); % Method to stop the generator
for j=1:2
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %1.1f ',0.1);% Generator gives an error if it turns on at 0
fclose(fid);
%%
iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\NWP.WND'];

fid=fopen(FFWindFile,'rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',2);
for j=1:11
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s" ',iecfile);
fclose(fid);
%%
for i=sp.i:length(Vhub)
    sp.i=i;
    try
        NWP(Vhub(i))
        
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
        y=['NWP_',num2str(Vhub(i)),'.outb'];
        u=PrimaryFile(1:end-4);
        t=[u,'.outb'];
        movefile(t,y)
        x='Simulating_DLCs\Results\DLC4_1';
        movefile(y,x)
    catch ME
    end
end
sp.i=1;
end