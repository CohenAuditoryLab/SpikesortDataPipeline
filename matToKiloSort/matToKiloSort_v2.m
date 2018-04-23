function matToKiloSort_v2(fbinary,fpath,num_channels)
%matToKiloSort  Run a KiloSort simulation using binary-converted TDT data.
%   matToKiloSort(fbinary,fpath,num_channels) will run KiloSort on fbinary
%   and save all data in fpath, including waveform graphs.
%   num_channels is needed to specify the exact number of channels in the
%   binary file.

%% initialize variables

addpath(genpath('C:\work\KiloSort-master')) % path to kilosort folder
addpath(genpath('C:\work\phy-master')) % path to npy-matlab scripts
pathToYourConfigFile = 'D:\SpikeSortingPipeline\Code\matToKiloSort';
fpath=[fpath '_AL'];
pathToUnmerged = [fpath,'\NoMerge'];

% specify location to store data files for this simulation
if ~exist(fpath, 'dir'); mkdir(fpath); end
if ~exist(pathToUnmerged, 'dir'); mkdir(pathToUnmerged); end

% run the config file to build the structure of options (ops)
run(fullfile(pathToYourConfigFile, 'config_v2.m'))
if mod(ops.Nfilt,32) ~= 0, ops.Nfilt = ops.Nfilt + 32 - mod(ops.Nfilt); end

if ops.GPU, gpuDevice(1); end % initialize GPU

createChannelMapFile(fpath,num_channels) % create and save file in specified location

%% process formatted data with KiloSort
[rez, DATA, uproj] = preprocessData_v2(ops,'AL'); % preprocess data and extract spikes
rez = fitTemplates(rez, DATA, uproj); % fit templates iteratively
rez_nomerge = fullMPMU(rez, DATA); % extract final spike times (overlapping extraction)
rez = merge_posthoc2(rez_nomerge); % use KiloSort's automerge functionality

%% save files
save(fullfile(pathToUnmerged, 'rez_AL_umerged.mat'), 'rez_nomerge', '-v7.3'); % save matlab results file
rezToPhy(rez_nomerge, pathToUnmerged); % save python results file for Phy

rezToPhy(rez, fpath); % save python results file for Phy
save(fullfile(pathToUnmerged,  'rez.mat'), 'rez', '-v7.3'); % save matlab results file
save(fullfile(fpath,  'rez_AL.mat'), 'rez', '-v7.3'); % save matlab results file
delete(ops.fproc); % remove temporary file

% save cluster plots
graphSpikes(fpath,rez);

% final display of total runtime
fprintf('KiloSort took %2.2f minutes to run \n', floor(toc/0.6)/100);

%%
addpath(genpath('C:\work\KiloSort-master')) % path to kilosort folder
addpath(genpath('C:\work\phy-master')) % path to npy-matlab scripts
pathToYourConfigFile = 'C:\work\KiloSort-master';
fpath(end-1:end)='ML';
pathToUnmerged = [fpath,'\NoMerge'];
% specify location to store data files for this simulation
if ~exist(fpath, 'dir'); mkdir(fpath); end
if ~exist(pathToUnmerged, 'dir'); mkdir(pathToUnmerged); end
% run the config file to build the structure of options (ops)
run(fullfile(pathToYourConfigFile, 'config_v2.m'))
if mod(ops.Nfilt,32) ~= 0, ops.Nfilt = ops.Nfilt + 32 - mod(ops.Nfilt); end
if ops.GPU, gpuDevice(1); end % initialize GPU
% ops.fbinary=[fpath '\'];
%createChannelMapFile(fpath,num_channels) % create and save file in specified location%% process formatted data with KiloSort
%%
[rez, DATA, uproj] = preprocessData_v2(ops,'ML'); % preprocess data and extract spikes
rez = fitTemplates(rez, DATA, uproj); % fit templates iteratively
rez_nomerge = fullMPMU(rez, DATA); % extract final spike times (overlapping extraction)
rezToPhy(rez_nomerge, pathToUnmerged); % save python results file for Phy
save(fullfile(pathToUnmerged,  'rez_MLunmerged.mat'), 'rez_nomerge', '-v7.3'); % save matlab results file
rez = merge_posthoc2(rez_nomerge); % use KiloSort's automerge functionality

%% save files
rezToPhy(rez, fpath); % save python results file for Phy
save(fullfile(fpath,  'rez.mat'), 'rez', '-v7.3'); % save matlab results file
delete(ops.fproc); % remove temporary file

% save cluster plots
graphSpikes(fpath,rez);

% final display of total runtime
fprintf('KiloSort took %2.2f minutes to run \n', floor(toc/0.6)/100);
end
