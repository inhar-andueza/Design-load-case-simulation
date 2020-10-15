function [] = DeleteEmpty( SimulationDirectory )
% Delete empty folders when simultations end

cd(SimulationDirectory)
cd('Simulating_DLCs\Results')

X=dir;
X=X(3:end);

for i=1:length(X)
Y=X(i).name;
cd(Y)
Z=dir;
if length(Z)<3
    cd('../')
    rmdir(Y)
else 
    cd('../')
end
end

ResetParameters

end





