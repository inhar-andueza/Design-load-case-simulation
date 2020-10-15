function [] = dlc(varargin)
%%
copyfile(fileparts(which('dlc')),'Simulating_DLCs')
SimulationDirectory = pwd;
addpath(genpath( SimulationDirectory ))
cd(SimulationDirectory)
%%
PrimaryFile = varargin{1};

fid = fopen(PrimaryFile);
for i=1:21
    fgetl(fid);
end
f1=fgetl(fid);
for i=1:3
    fgetl(fid);
end
f2=fgetl(fid);
fgetl(fid);
f3=fgetl(fid);
fclose(fid);

sf1 = strsplit(f1);
sf2 = strsplit(f2);
sf3 = strsplit(f3);

elastodyn = strsplit(strrep(strrep(sf1{1},'\',' '),'"',''));
elastodyn = elastodyn{end};

inflowwind = strsplit(strrep(strrep(sf2{1},'\',' '),'"',''));
inflowwind = inflowwind{end};

servodyn = strsplit(strrep(strrep(sf3{1},'\',' '),'"',''));
servodyn = servodyn{end};

FFWindFile = which(inflowwind);
InitialConditions = which(elastodyn);
SimulationControl = which(servodyn);
%%
UnchangedPrimary = ['Simulating_DLCs\Unchanged\',PrimaryFile];
UnchangedServoDyn = ['Simulating_DLCs\Unchanged\',servodyn];
UnchangedElastoDyn = ['Simulating_DLCs\Unchanged\',elastodyn];

RunFAST = ['FAST ',PrimaryFile];

sp = matfile('SaveParameters','Writable',true);

%Postprocess 
mlf = 'MlifeFile.mlif';
mef = 'MextremesFile.mext';
%%
for i=2:nargin
    inputfile = varargin{i};
    %% Reset simulations
    if isequal(inputfile,'reset')
        ResetParameters
        rp = [];
    end
    %% Random seed
    if isnumeric(inputfile) && isscalar(inputfile)  
        seed = rng(inputfile);
        sp.R = seed.State;
    end
end
%%
CreateResults()
cd( SimulationDirectory )
%%
CopyUnchanged(PrimaryFile,FFWindFile,SimulationControl,InitialConditions)
%% Wind Speed
for i=2:nargin
    inputfile = varargin{i};
    if isnumeric(inputfile) && not(isscalar(inputfile))
        Vin = min(inputfile);
        Vout = max(inputfile);
        Vr = median(inputfile);
        V = true;
    end
end
if not(exist('Vr','var'))
    Vin = 3; % Default cut-in wind speed [m/s]
    Vout = 25; % Default cut-out wind speed [m/s]
    Vr = 11.4; % Default rated wind speed [m/s]
    V = false;
end
%%
if  nargin < 2 || (nargin > 1 && nargin < 3 && (V == true || exist('seed','var') || exist('rp','var'))) || (nargin > 2 && nargin < 4 && ((V == true && exist('rp','var')) || (V == true && exist('seed','var')) || (exist('seed','var') && exist('rp','var')))) || (nargin > 3 && nargin < 5 && V == true && exist('rp','var') && exist('seed','var'))
    RunALL( PrimaryFile,SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,RunFAST )
    RunPP( SimulationDirectory,mlf,mef,sp )
else
    %%
    for i=2:nargin
        
        inputfile = varargin{i};
        %%
        switch(inputfile)
            
            case 'fatigue'
                RunFatigue( PrimaryFile,SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,RunFAST,Vin,Vout )
                
            case 'ultimate strength'
                RunUltS( PrimaryFile,SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,RunFAST,Vin,Vr,Vout )
                
            case 'postprocess'
                RunPP( SimulationDirectory,mlf,mef,sp )
                
            case 'all'
                RunALL( PrimaryFile,SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,RunFAST,Vin,Vr,Vout )
                
            case 'DLC 1.1'
                sp.dlc = 1;
                DLC1_1( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 1.2'
                sp.dlc = 2;
                DLC1_2( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 1.3'
                sp.dlc = 3;
                DLC1_3( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 1.4'
                sp.dlc = 4;
                DLC1_4( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vr )
                
            case 'DLC 1.5'
                sp.dlc = 5;
                DLC1_5( SimulationDirectory,FFWindFile,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 2.1'
                sp.dlc = 6;
                DLC2_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 2.2'
                sp.dlc = 7;
                DLC2_2( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 2.3'
                sp.dlc = 8;
                DLC2_3( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,sp,PrimaryFile,RunFAST,Vr,Vout )
                
            case 'DLC 2.4'
                sp.dlc = 9;
                DLC2_4( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 3.1'
                sp.dlc = 10;
                DLC3_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 3.2'
                sp.dlc = 11;
                DLC3_2( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vr )
                
            case 'DLC 3.3'
                sp.dlc = 12;
                DLC3_3( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vr )
                
            case 'DLC 4.1'
                sp.dlc = 13;
                DLC4_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 4.2'
                sp.dlc = 14;
                DLC4_2( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
                
            case 'DLC 5.1'
                sp.dlc = 15;
                DLC5_1( SimulationDirectory,FFWindFile,SimulationControl,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 6.1'
                sp.dlc = 16;
                DLC6_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
                
            case 'DLC 6.2'
                sp.dlc = 17;
                DLC6_2( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
                
            case 'DLC 6.3'
                sp.dlc = 18;
                DLC6_3( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
                
            case 'DLC 6.4'
                sp.dlc = 19;
                DLC6_4( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vin,Vout )
                
            case 'DLC 7.1'
                sp.dlc = 20;
                DLC7_1( SimulationDirectory,FFWindFile,SimulationControl,InitialConditions,UnchangedPrimary,UnchangedServoDyn,UnchangedElastoDyn,sp,PrimaryFile,RunFAST,Vr )
        end
    end
    sp.dlc = 1;
end
DeleteEmpty( SimulationDirectory )
end