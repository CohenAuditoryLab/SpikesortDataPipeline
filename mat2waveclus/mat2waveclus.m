function mat2waveclus(filename)
% handle slashes
if(ispc)
    slash = '\';
else
    slash = '/';
end

%select path for data
disp('Select the path for your .mat data');
path = uigetdir();
cd(path);

disp(['Loading ' filename]);
load(filename);
data_directory = [path slash 'wave_clus_output'];
if 7~=exist(data_directory, 'dir') mkdir(data_directory); end
cd(data_directory);

%define data
data_temp = spikesML;
r = size(data_temp, 1);

%select path for wave_clus
disp('Select the path for wave_clus');
waveclus = uigetdir();
%cd(waveclus);
addpath(genpath(waveclus));
%define sampling rate, timestamps, and parameters
sr = 24410;
index = (0:size(data_temp,2)-1)/sr;
param.stdmin = 3.5;
param.segments_length = 10;
param.to_plot_std = 2;
param.detect_fmax = 7000;

%define matrix for storing all outputs
allClusters = cell(1,r);

for n = 1:r
    data = data_temp(n, :);
    
    name = strcat(filename, '_channel', num2str(n));
    ext = '.mat';
    
    %save .mat file
    save(strcat(name, ext), 'data', 'index', 'sr');
    
    %make cell with name of files to use
    file = {strcat(name, ext)};
    
    disp(['Processing channel ', num2str(n), ' of ', num2str(r)]);
    
    %Get spikes
    Get_spikes(file, 'par', param, 'parallel', true);
    %outputs filename_spikes.mat
    
    %get clusters
    Do_clustering(strcat(name, '_spikes', ext), 'parallel', true);
    
    %load clustering results
    load(strcat('times_', name, ext));
    
    %add clustering results to all matrix
    allClusters{n} = cluster_class;
end

disp('Saving final data matrix...');
save(strcat('clusters_', filename), 'allClusters');
disp('Done!');

end