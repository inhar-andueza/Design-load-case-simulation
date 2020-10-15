function [] = RunPP( SimulationDirectory,mlf,mef,sp )
cd( SimulationDirectory )
%% Postprocess
for i=sp.m:2
    if i<2
        %%
        MLife( SimulationDirectory,mlf,sp )
    elseif i>1
        %%
        MExtremes_f( SimulationDirectory,mef,sp )
    end
    cd('../')
end
sp.m=1;
end