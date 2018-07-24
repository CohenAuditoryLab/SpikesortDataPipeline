function matToKiloSort(fbinary,fpath)
%matToKiloSort  Run a KiloSort simulation using binary-converted TDT data.
%   matToKiloSort(fbinary,fpath,num_channels) will run KiloSort on fbinary
%   and save all data in fpath, including waveform graphs.
%   num_channels is needed to specify the exact number of channels in the
%   binary file.

%% initialize variables

addpath(genpath('C:\work\KiloSort-master')) % path to kilosort folder
addpath(genpath('C:\work\phy-master')) % path to npy-matlab scripts
pathToYourConfigFile = 'C:\work\chris_raw_data';
pathToUnmerged = [fpath,'\NoMerge'];

% specify location to store data files for this simulation
if ~exist(fpath, 'dir'); mkdir(fpath); end
if ~exist(pathToUnmerged, 'dir'); mkdir(pathToUnmerged); end

% run the config file to build the structure of options (ops)
run(fullfile(pathToYourConfigFile, 'config_CA061.m'))
%if mod(ops.Nfilt,32) ~= 0, ops.Nfilt = ops.Nfilt + 32 - mod(ops.Nfilt); end

if ops.GPU, gpuDevice(1); end % initialize GPU

%createChannelMapFile(fpath,num_channels) % create and save file in specified location

%% process formatted data with KiloSort
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes
rez = fitTemplates(rez, DATA, uproj); % fit templates iteratively
% extract final spike times (overlapping extraction)
rez_nomerge = fullMPMU(rez, DATA); 
%saving unmerged results to phy
rezToPhy(rez_nomerge, pathToUnmerged); % save unmerged python results file for Phy
%Automerge
rez_merged = merge_posthoc2(rez_nomerge); % use KiloSort's automerge functionality

%% save files
rezToPhy(rez_merged, fpath); % save merged results file for Phy
save(fullfile(pathToUnmerged,  'rez.mat'), 'rez_nomerge', '-v7.3'); % save matlab results file
save(fullfile(fpath,  'rez.mat'), 'rez_merged', '-v7.3'); % save matlab results file
delete(ops.fproc); % remove temporary file
% save cluster plots from merged
%graphSpikes(fpath,rez);
% final display of total runtime
fprintf('KiloSort took %2.2f minutes to run \n', floor(toc/0.6)/100);
end
