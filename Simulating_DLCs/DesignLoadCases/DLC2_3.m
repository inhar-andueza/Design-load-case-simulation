function [] = DLC2_3( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,sp,PrimaryFile,RunFAST,Vr )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
%% DLC 2.3
Vhub=(Vr-2):0.2:(Vr+2);
%For DLC 2.3 the design standard requires six 1-min simulations at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'       %2.0f ',90); % 1 min = 60 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
% Start of the  IEC transient condition
fid=fopen('IEC.ipt','rt+');
for j=1:7
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'%2.0f.',60);
fclose(fid);

fid=fopen(FFWindFile,'rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',2);
fclose(fid);
%%
for i=sp.i:length(Vhub)
    sp.i=i;
    
    cd('Simulating_DLCs\Results\DLC2_3')
    mkdir EOG
    cd(SimulationDirectory)
    %%
    for k=sp.k:6
        sp.k=k;
        try
            EOG(Vhub(i))
            
            cd(SimulationDirectory)
            %%
            iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EOG_01_R.WND'];
            
            fid=fopen(FFWindFile,'rt+');
            for j=1:15
                fgetl(fid);
            end
            fseek(fid,0,'cof');
            fprintf(fid,'"%s" ',iecfile);
            fclose(fid);
            
            %% Change primary.fst to grid loss and shutdown conditions
            Gt=60:2:70; % Time at which the load is lost relative to the gust
            
            fid=fopen(SimulationControl,'rt+');
            for j=1:8
                fgetl(fid);
            end
            for j=1:3
                fseek(fid,0,'cof');
                fprintf(fid,'         %2.1f ',Gt(k)+0.2); % Time to start override pitch maneuver = Time to turn off the generator + 0.2 sec delay to detect the fault
                fgetl(fid);
            end
            for j=1:3
                fgetl(fid);
            end
            for j=1:3
                fseek(fid,0,'cof');
                fprintf(fid,'         %2.0f ',90); % Blade end pitch
                fgetl(fid);
            end
            for j=1:8
                fgetl(fid);
            end
            fseek(fid,0,'cof');
            fprintf(fid,'          %2.0f  ',Gt(k)); % Time to turn off the generator
            fclose(fid);
            %%
            system(RunFAST);
            %%
            y=['EOG_01_R_',num2str(k),'.outb'];
            u=PrimaryFile(1:end-4);
            t=[u,'.outb'];
            movefile(t,y)
            x='Simulating_DLCs\Results\DLC2_3\EOG';
            movefile(y,x)
            %% Outputs should be the same for the three Vout cases
            if Vhub(i)==Vrated
                cd('Simulating_DLCs\Results\DLC2_3')
                mkdir EOG_OUT
                cd(SimulationDirectory)
                
                iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EOG_01_O.WND'];
                
                fid=fopen(FFWindFile,'rt+');
                for j=1:15
                    fgetl(fid);
                end
                fseek(fid,0,'cof');
                fprintf(fid,'"%s" ',iecfile);
                fclose(fid);
                
                system(RunFAST);
                
                y=['EOG_01_O_',num2str(k),'.outb'];
                u=PrimaryFile(1:end-4);
                t=[u,'.outb'];
                movefile(t,y)
                x='Simulating_DLCs\Results\DLC2_3\EOG_OUT';
                movefile(y,x)
            end
        catch ME
        end
    end
    z=10*Vhub(i);
    cd('Simulating_DLCs\Results\DLC2_3')
    a=['EOG_',num2str(z)];
    movefile('EOG',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end