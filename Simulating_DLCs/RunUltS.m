function [] = RunUltS( PrimaryFile,SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,RunFAST,Vin,Vr,Vout )
cd( SimulationDirectory )
%%
for i=sp.dlcs
    sp.dlc=i;
    if i<2
        %%
        DLC1_1( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 2<i && i<4
        %%
        DLC1_3( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 3<i && i<5
        %%
        DLC1_4( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vr )
    elseif 4<i && i<6
        %%
        DLC1_5( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 5<i && i<7
        %%
        DLC2_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 6<i && i<8
        %%
        DLC2_2( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 7<i && i<9
        %%
        DLC2_3( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,sp,PrimaryFile,RunFAST,Vr,Vout )
    elseif 10<i && i<12
        %%
        DLC3_2( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vr )
    elseif 11<i && i<13
        %%
        DLC3_3( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vr )
    elseif 13<i && i<15
        %%
        DLC4_2( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
    elseif 14<i && i<16
        %%
        DLC5_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
    elseif 15<i && i<17
        %%
        DLC6_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
    elseif 16<i && i<18
        %%
        DLC6_2( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
    elseif 17<i && i<19
        %%
        DLC6_3( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
    elseif i>19
        %%
        DLC7_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
    end
end
sp.dlc=1;
end