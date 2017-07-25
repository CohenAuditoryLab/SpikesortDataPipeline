function matToWaveClus(fbinary,fpath,num_channels)
%matToWaveClus  Run a WaveClus simulation using binary-converted TDT data.
%   matToWaveClus(fbinary,fpath,num_channels) will run WaveClus on fbinary
%   and save all data in fpath, including waveform graphs.
%   num_channels is needed to specify the exact number of channels in the
%   binary file.

%% initialize variables

addpath(genpath('C:\work\wave_clus')) % path to waveclus folder

% specify location to store data files for this simulation
if ~exist(fpath, 'dir'); mkdir(fpath); end
cd(fpath);

sr = 24414.0625;
param.stdmin = 3.5;
param.segments_length = 10;
param.to_plot_std = 2;
param.detect_fmax = 7000;
allClusters = cell(1,num_channels); % define matrix for storing all outputs

%% process formatted data with WaveClus

file = dir(fbinary);
row_length = file.bytes/num_channels;
index = (0:row_length-1)/sr; %#ok<NASGU>
fid = fopen(fbinary,'r');

for n = 1:num_channels
    % read one row of the file and advance pointer
    data = fread(fid,[1,row_length],'*int16'); %#ok<NASGU>
    name = ['channel_' num2str(n) '.mat'];
    
    save(fullfile(fpath,name), ...
        'data', 'index', 'sr'); % save .mat file
    disp(['Processing channel ', num2str(n), ' of ', num2str(num_channels)]);

    Get_spikes({name}, 'par', param, 'parallel', true); % outputs filename_spikes.mat
    Do_clustering([name(1:end-4) '_spikes' '.mat'], 'parallel', true);
    
    % load clustering results
    load(strcat('times_', name(1:end-4)));
    % add clustering results to all matrix
    allClusters{n} = cluster_class;
    
    clear data
end

%% save final results

disp('Saving final data matrix...');
save('all_clusters', 'allClusters');
disp('Done!');

end
