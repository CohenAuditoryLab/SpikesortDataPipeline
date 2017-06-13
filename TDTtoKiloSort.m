function TDTtoKiloSort(tank, block, varargin)

% specify location to store data files for this simulation
fpath = 'C:\work\Spikes\TDTtoKiloSort\';
if ~exist(fpath, 'dir'); mkdir(fpath); end

addpath(genpath('C:\work\KiloSort-master')) % path to kilosort folder
addpath(genpath('C:\work\phy-master')) % path to npy-matlab scripts
pathToYourConfigFile = 'C:\work\TDTtoKiloSort'; % path to the config file

% run the config file to build the structure of options (ops)
run(fullfile(pathToYourConfigFile, 'config.m'))

if ops.GPU, gpuDevice(1); end %#ok initialize GPU
tic; % start timer

% format raw TDT data
data = TDT2mat(tank, block, varargin); % extract data from tank file
rData = data.streams.NRaw.data; % n x m matrix, n = num electrodes, m = timesteps
ops.fs = data.streams.NRaw.fs; % set sampling rate

% store formatted data
fidW = fopen(fullfile(fpath, 'sim_binary.dat'), 'w');
fwrite(fidW, rData, 'int16');
fclose(fidW);

% process formatted data with KiloSort
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes
rez = fitTemplates(rez, DATA, uproj); % fit templates iteratively
rez = fullMPMU(rez, DATA); % extract final spike times (overlapping extraction)
rez = merge_posthoc2(rez); % use KiloSort's automerge functionality

rezToPhy(rez, fpath); % save python results file for Phy
save(fullfile(fpath,  'rez.mat'), 'rez', '-v7.3'); % save matlab results file
delete(ops.fproc); % remove temporary file

% final display of total runtime
fprintf('KiloSort took %2.2f minutes to run \n', floor(toc/0.6)/100)
end
