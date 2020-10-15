function [] = DLC2_4( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
cd('Simulating_DLCs')
X=dir('Results/DLC1_1');
%%
if length(X)<3
    %%
    DLC2_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    DLC_2_1=[SimulationDirectory,'\Simulating_DLCs\Results\DLC2_1\'];
    DLC_2_4=[SimulationDirectory,'\Simulating_DLCs\Results\DLC2_4'];
else      
    DLC_2_1=[SimulationDirectory,'\Simulating_DLCs\Results\DLC2_1\'];
    DLC_2_4=[SimulationDirectory,'\Simulating_DLCs\Results\DLC2_4'];
end
%%
cd(DLC_2_4)
%%    
copyfile(DLC_2_1,DLC_2_4);

cd(SimulationDirectory)
end