%config  Build the structure of options (ops) for a KiloSort simulation.

ops.GPU         = 1; % whether to run this code on an Nvidia GPU
ops.parfor      = 0; % whether to use parfor to accelerate parts of algorithm
ops.verbose     = 1; % whether to print command line progress
ops.showfigures = 1; % whether to plot figures during optimization

%% options for data storage
ops.datatype = 'dat'; % binary ('dat', 'bin') or 'openEphys'
ops.fbinary  = fullfile(fpath, 'sim_binary.dat'); % will be created for 'openEphys'
ops.fproc    = fullfile(fpath, 'temp_wh.dat'); % residual of RAM of preprocessed data
ops.root     = fpath; % 'openEphys' only: where raw files are

%% options for channels and clustering
ops.Nfilt    = 128; % number of clusters to use (2-4x more than Nchan, multiple of 32)
ops.nNeighPC = 12;  % visual only (Phy): num channels to mask the PCs
ops.nNeigh   = 16;  % visual only (Phy): num neighbor templates to retain projections of

% options for channel whitening
ops.whitening = 'full'; % type of whitening
ops.nSkipCov = 1; % compute whitening matrix from every N-th batch
ops.whiteningRange = 32; % how many channels to whiten together

% define the channel map as a filename made using createChannelMapFile.m
ops.chanMap = fullfile(fpath, 'chanMap.mat');

% fraction of "noise" templates allowed to span all channel groups
% (see createChannelMapFile for more info).
ops.criterionNoiseChannels = 0.2;

%% options for controlling model and optimization
ops.Nrank       = 3;     % matrix rank of spike template model
ops.nfullpasses = 6;     % num complete passes through data during optimization
ops.maxFR       = 20000; % maximum number of spikes to extract per batch
ops.fshigh      = 300;   % frequency for high pass filtering
ops.ntbuff      = 64;    % samples of symmetrical buffer for whitening and spike detection
ops.scaleproc   = 200;   % int16 scaling of whitened data
ops.NT          = 32*1024+ ops.ntbuff; % batch size (try decreasing if out of memory)
                                       % for GPU should be multiple of 32 + ntbuff

%% options to improve/deteriorate results
% when multiple values are provided for an option, the first two are beginning
% and ending anneal values, the third is the value used in the final pass.
ops.Th  = [4 10 10]; % threshold for detecting spikes on template-filtered data
ops.lam = [5 20 20]; % large means amplitudes are forced around the mean
ops.nannealpasses    = 4;           % should be less than nfullpasses
ops.momentum         = 1./[20 400]; % start with high momentum and anneal
ops.shuffle_clusters = 1;           % allow merges and splits during optimization
ops.mergeT           = .1;          % upper threshold for merging
ops.splitT           = .1;          % lower threshold for splitting
		
%% options for initializing spikes from data
ops.initialize      = 'no';    % 'fromData' or 'no'
ops.spkTh           = -6;      % spike threshold in standard deviations
ops.loc_range       = [3  1];  % ranges to detect peaks; plus/minus in time and channel
ops.long_range      = [30  6]; % ranges to detect isolated peaks
ops.maskMaxChannels = 5;       % how many channels to mask up/down
ops.crit            = .65;     % upper criterion for discarding spike repeates
ops.nFiltMax        = 10000;   % maximum "unique" spikes to consider

% load predefined principal components (visualization only (Phy): used for features)
dd       = load('PCspikes2.mat'); % you might want to recompute this from your own data
ops.wPCA = dd.Wi(:,1:7);          % PCs

%% options for posthoc merges (under construction)
ops.fracse = 0.1; % binning step along discriminant axis for posthoc merges (in units of sd)
ops.epu = Inf;
ops.ForceMaxRAMforDat = 20e9; % max RAM the algorithm will try to use; will autodetect on Windows
