function [] = MExtremes_f( SimulationDirectory,mef,sp )
%%
cd('Simulating_DLCs')
X=dir('Results');
X=struct2cell(X);
X=char(X(1,3:end));
%% Input files
for i=sp.pp:length(X(:,1))
    sp.pp=i;
    %%
    cd('Results')
    V=dir(X(i,:));
    %%
    if length(V)>2
        V(1:2)=[];
        P=struct2cell(V);
        %%
        for k=1:length(V)
            if V(k).isdir==1
                N(k,1)=P(1,k);
            end
        end
        %%
        N = N(cellfun('isclass', N, 'char'));
        Y=char(N);
        cd(X(i,:))
        %%
        if i<2
            MExtremes_DLC1_1( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>2 && i<4
            MExtremes_DLC1_3( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>3 && i<5
            MExtremes_DLC1_4( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>4 && i<6
            MExtremes_DLC1_5( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>5 && i<7
            MExtremes_DLC2_1( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>6 && i<8
            MExtremes_DLC2_2( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>7 && i<9
            MExtremes_DLC2_3( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>10 && i<12
            MExtremes_DLC3_2( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>11 && i<13
            MExtremes_DLC3_3( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>13 && i<15
            MExtremes_DLC4_2( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>14 && i<16
            MExtremes_DLC5_1( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>15 && i<17
            MExtremes_DLC6_1( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>16 && i<18
            MExtremes_DLC6_2( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>17 && i<19
            MExtremes_DLC6_3( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        elseif i>19
            MExtremes_DLC7_1( Y,SimulationDirectory,mef,sp )
            cd('Simulating_DLCs')
            
        else
            cd('../..')
        end
        clear N
    else
        cd('../')  
    end 
end
sp.pp=1;
end