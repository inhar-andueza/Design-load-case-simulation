function [] = MLife( SimulationDirectory,mlf,sp )
%%
cd('Simulating_DLCs')
X=dir('Results');
X=struct2cell(X);
X=char(X(1,3:end));
%% Input files
normal=183;%Normal events previous line
idling=184;%Idling events previous line
discrete=185;%Discrete events previous line
%%
for i=sp.pp:length(X(:,1))
    sp.pp=i;
    %%
    cd('Results')
    V=dir(X(i,:));
    
    if length(V)>2
        V(1:2,:)=[];
        P=struct2cell(V);
        for k=1:length(V)
            if V(k).isdir==1
                N(k,1)=P(1,k);
            end
        end
        N = N(cellfun('isclass', N, 'char'));
        Y = char(N);
        cd(X(i,:))
        %%
        if i>1 && i<3
            Mlife_DLC1_2(Y,X,i,normal,SimulationDirectory,mlf,sp )
            cd('Simulating_DLCs')
        
        elseif i>8 && i<10
            Mlife_DLC2_4(Y,X,i,discrete,SimulationDirectory,mlf,sp )
            cd('Simulating_DLCs')
        
        elseif i>9 && i<11
            Mlife_DLC3_1(Y,X,i,discrete,SimulationDirectory,mlf,sp )
            cd('Simulating_DLCs')
            
        elseif i>12 && i<14                                                                                                                                                  
            Mlife_DLC4_1(Y,X,i,discrete,SimulationDirectory,mlf,sp )                                                                                                    
            cd('Simulating_DLCs')
            
        elseif i>18 && i<20
            Mlife_DLC6_4(Y,X,i,idling,SimulationDirectory,mlf,sp )
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