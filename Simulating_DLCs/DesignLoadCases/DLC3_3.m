function [] = DLC3_3( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vr )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 3.3
Vhub=[Vin,(Vr-2):0.2:(Vr+2)];
%For DLC 3.3 the design standard requires six 1-min simulations at each wind condition
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
%% Change primary.fst to normal startup
fid=fopen(SimulationControl,'rt+');
for j=1:21
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%s','False'); % Method to start the generator
for j=1:2
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'        %3.0f ',300); % Speed to turn on the generator
%%
fid=fopen(InitialConditions,'rt+');
for j=1:29
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'        %2.0f ',90); % Feather pitch position 90º
    fgetl(fid);
end
for j=1:2
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %1.2f ',0.01); % Initial rotor speed must be near to zero, zero gives an error
fclose(fid);
%%
Gt=60:2:70;
%%
for i=sp.i:length(Vhub)
    sp.i=i;
    %%
    cd('Simulating_DLCs\Results\DLC3_3')
    mkdir EDC
    cd(SimulationDirectory)
    
    for k=sp.k:6
        sp.k=k;
        try
            fid=fopen('IEC.ipt','rt+');
            for j=1:7
                fgetl(fid);
            end
            fseek(fid,0,'cof');
            fprintf(fid,'%2.0f.',Gt(k));
            fclose(fid);
            
            EDC(Vhub(i))
            
            cd(SimulationDirectory)
            %%
            iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EDC_50NR.WND'];
            
            fid=fopen(FFWindFile,'rt+');
            for j=1:15
                fgetl(fid);
            end
            fseek(fid,0,'cof');
            fprintf(fid,'"%s" ',iecfile);
            fclose(fid);
            
            system(RunFAST);
            
            y=['EDC_50NR_',num2str(k),'.outb'];
            u=PrimaryFile(1:end-4);
            t=[u,'.outb'];
            movefile(t,y)
            x='Simulating_DLCs\Results\DLC3_3\EDC';
            movefile(y,x)
            %% Outputs should be the same for the three Vout cases
            if Vhub(i)==Vrated
                cd('Simulating_DLCs\Results\DLC3_3')
                mkdir EDC_OUT
                cd(SimulationDirectory)
                
                fid=fopen('IEC.ipt','rt+');
                for j=1:7
                    fgetl(fid);
                end
                fseek(fid,0,'cof');
                fprintf(fid,'%2.0f.',Gt(k));
                fclose(fid);
                
                EDC(Vhub(i))
                
                cd(SimulationDirectory)
                
                iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EDC_50NO.WND'];
                
                fid=fopen(FFWindFile,'rt+');
                for j=1:15
                    fgetl(fid);
                end
                fseek(fid,0,'cof');
                fprintf(fid,'"%s" ',iecfile);
                fclose(fid);
                
                system(RunFAST);
                
                y=['EDC_50NO_',num2str(k),'.outb'];
                u=PrimaryFile(1:end-4);
                t=[u,'.outb'];
                movefile(t,y)
                movefile(y,'Simulating_DLCs\Results\DLC3_3\EDC_OUT')
            end
        catch ME
        end
        %%
        try
            iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EDC_50PR.WND'
            
            fid=fopen(FFWindFile,'rt+');
            for j=1:15
                fgetl(fid);
            end
            fseek(fid,0,'cof');
            fprintf(fid,'"%s" ',iecfile);
            fclose(fid);
            
            system(RunFAST);
            
            y=['EDC_50PR_',num2str(k),'.outb'];
            u=PrimaryFile(1:end-4);
            t=[u,'.outb'];
            movefile(t,y)
            x='Simulating_DLCs\Results\DLC3_3\EDC';
            movefile(y,x)
            %% Outputs should be the same for the three Vout cases
            if Vhub(i)==Vrated
                cd('Simulating_DLCs\Results\DLC3_3')
                mkdir EDC_OUT
                cd(SimulationDirectory)
                
                iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EDC_50PO.WND'];
                
                fid=fopen(FFWindFile,'rt+');
                for j=1:15
                    fgetl(fid);
                end
                fseek(fid,0,'cof');
                fprintf(fid,'"%s" ',iecfile);
                fclose(fid);
                
                system(RunFAST);
                
                y=['EDC_50PO_',num2str(k),'.outb'];
                u=PrimaryFile(1:end-4);
                t=[u,'.outb'];
                movefile(t,y)
                x='Simulating_DLCs\Results\DLC3_3\EDC_OUT';
                movefile(y,x)
            end
        catch ME
        end
    end
    z=10*Vhub(i);
    cd('Simulating_DLCs\Results\DLC3_3')
    a=['EDC_',num2str(z)];
    movefile('EDC',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end