function [] = DLC1_1( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
%% DLC 1.1
Vhub=Vin:2:Vout;
%For DLC 1.1 the –3 design standard requires that six 10-min simulations be run at each wind condition,
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %3.0f ',630); % 10 min = 600 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
%%
turbsimfile = [SimulationDirectory,'\Simulating_DLCs\WindData\TW\TurbSim.bts'];

fid=fopen(FFWindFile,'rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',3);
for j=1:15
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'"%s" ',turbsimfile);
fclose(fid);
%%
for i=sp.i:length(Vhub)
    sp.i=i;
    %%
    cd('Simulating_DLCs\Results\DLC1_1')
    mkdir NTM
    cd(SimulationDirectory)
    %%
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
            x='Simulating_DLCs\Results\DLC1_1\NTM';
            movefile(y,x)
        catch ME
        end
    end
    cd('Simulating_DLCs\Results\DLC1_1')
    a=['NTM_',num2str(Vhub(i))];
    movefile('NTM',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end