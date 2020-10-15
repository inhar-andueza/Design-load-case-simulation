function [] = RunFatigue( PrimaryFile,SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,RunFAST,Vin,Vout )
cd( SimulationDirectory )
%%
for i=sp.dlcs
    sp.dlc=i;
    if 1<i && i<3
        %%
        DLC1_2( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout  )
        %%
    elseif 8<i && i<10
        %%
        DLC2_4( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 9<i && i<11
        %%
        DLC3_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 12<i && i<14
        %%
        DLC4_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 18<i && i<20
        %%
        DLC6_4( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
    end
end
sp.dlc=1;
end