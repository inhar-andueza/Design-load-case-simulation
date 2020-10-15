function [] = DLC1_2( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
cd('Simulating_DLCs')
X=dir('Results/DLC1_1');
%%
if length(X)<3
    %%
    DLC1_1( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    DLC_1_1=[SimulationDirectory,'\Simulating_DLCs\Results\DLC1_1\'];
    DLC_1_2=[SimulationDirectory,'\Simulating_DLCs\Results\DLC1_2'];
else
    DLC_1_1=[SimulationDirectory,'\Simulating_DLCs\Results\DLC1_1\'];
    DLC_1_2=[SimulationDirectory,'\Simulating_DLCs\Results\DLC1_2'];
end
%%
cd(DLC_1_2)
%%    
copyfile(DLC_1_1,DLC_1_2);

cd(SimulationDirectory)
end