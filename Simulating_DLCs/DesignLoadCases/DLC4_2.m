function [] = DLC4_2( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
cd(SimulationDirectory)
copyfile(UnchangedPrimary)
copyfile(UnchangedServoDyn)
copyfile(UnchangedElastoDyn)
%% DLC 4.2
Vhub=(Vr-2):0.2:(Vr+2);
%For DLC 4.2 the design standard requires six 1-min simulations at each wind condition
fid=fopen(PrimaryFile,'rt+');
for j=1:5
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'         %2.0f ',90); % 1 min = 60 sec + 30 sec to eliminate start-up transient behaviour
fclose(fid);
%% Change primary.fst to normal pitch to feather shutdown
fid=fopen(SimulationControl,'rt+');
for j=1:8
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.0f ',30); % Time to start override pitch maneuver
    fgetl(fid);
end
for j=1:3
    fgetl(fid);
end
for j=1:3
    fseek(fid,0,'cof');
    fprintf(fid,'         %2.0f ',90); % Feather pitch angle
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
fprintf(fid,'        %1.1f ',0.1);
fclose(fid);
%%
fid=fopen(FFWindFile,'rt+');
for j=1:4
    fgetl(fid);
end
fseek(fid,0,'cof');
fprintf(fid,'          %1.0f ',2);
%% Pitch to Feather
Gt=60:2:70;
%%
for i=sp.i:length(Vhub)
    sp.i=i;
    %%
    cd('Simulating_DLCs\Results\DLC4_2')
    mkdir EOG
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
            
            EOG(Vhub(i))
            
            cd(SimulationDirectory)
            
            iecfile = [SimulationDirectory,'\Simulating_DLCs\WindData\EW\EOG_01_R.WND'];
            
            fid=fopen(FFWindFile,'rt+');
            for j=1:15
                fgetl(fid);
            end
            fseek(fid,0,'cof');
            fprintf(fid,'"%s" ',iecfile);
            fclose(fid);
            %%
            system(RunFAST);
            
            y=['EOG_01_R_',num2str(k),'.outb'];
            u=PrimaryFile(1:end-4);
            t=[u,'.outb'];
            movefile(t,y)
            x='Simulating_DLCs\Results\DLC4_2\EOG';
            movefile(y,x)
            %% Outputs should be the same for the three Vout cases
            if Vhub(i)==Vrated
                cd('Simulating_DLCs\Results\DLC4_2')
                mkdir EOG_OUT
                
                cd(SimulationDirectory)
                
                fid=fopen('IEC.ipt','rt+');
                for j=1:7
                    fgetl(fid);
                end
                fseek(fid,0,'cof');
                fprintf(fid,'%2.0f.',Gt(k));
                fclose(fid);
                
                EOG(Vhub(i))
                
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
                t=[PrimaryFile,'.outb'];
                movefile(t,y)
                movefile(y,'Simulating_DLCs\Results\DLC4_2\EOG_OUT')
            end
        catch ME
        end
    end
    z=10*Vhub(i);
    cd('Simulating_DLCs\Results\DLC4_2')
    a=['EOG_',num2str(z)];
    movefile('EOG',a)
    cd(SimulationDirectory)
    sp.k=1;
end
sp.i=1;
end