function [] = CopyUnchanged(PrimaryFile,FFWindFile,SimulationControl,InitialConditions)
%Copy necessary files in the unchanged folder

copyfile(PrimaryFile,'Unchanged')
copyfile(FFWindFile,'Unchanged')
copyfile(SimulationControl,'Unchanged')
copyfile(InitialConditions,'Unchanged')
% copyfile(mlf,'Simulating_DLCs\Unchanged')
% copyfile(mef,'Simulating_DLCs\Unchanged')

end

