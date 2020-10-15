function [] = DLC5_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr,Vout )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 5.1 Emergency shutdown after grid loss
Vhub=(Vr-2):0.2:(Vr+2);
Vhub=[Vhub,Vout];
%For DLC 5.1 the –3 design standard requires that twelve 10-min simulations be run at each wind condition,
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'       %3.0f ',630); % 10 min = 600 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
%% Change primary.fst to emergency shutdown conditions
fid=fopen(SimulationControl,'rt+');
for j=1:8
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.0f ',90);
    fgetl(fid);
end
for j=1:3
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.0f ',90);
    fgetl(fid);
end
for j=1:29
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %1.0f ',1);
fgetl(fid);
fseek(fid,0,'cof');
fprintf(fid,'        %2.0f ',90);% Time to apply the brake
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
    
    cd('Simulating_DLCs\Results\DLC5_1')
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
            x='Simulating_DLCs\Results\DLC5_1\NTM';
            movefile(y,x)
        catch ME
        end
    end
    z=10*Vhub(i);
    cd('Simulating_DLCs\Results\DLC5_1')
    a=['NTM_',num2str(z)];
    movefile('NTM',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end