function mat2waveclus_v2(pathbin,filename,number_channels)
% handle slashes
if nargin<3
    number_channels=192; 
end
if nargin<2
    [filename,pathbin,~] = uigetfile('*.dat');
end

if(ispc)
    slash = '\';
else
    slash = '/';
end

sr = 24414.0625;
param.stdmin = 3.5;
param.segments_length = 10;
param.to_plot_std = 2;
param.detect_fmax = 7000;

% %select path for data
% disp('Select the path for your .dat binary file'); Given in selectfile
% pathbin = uigetdir();
%cd(path);

data_directory = [pathbin 'wave_clus_output'];
if 7~=exist(data_directory, 'dir') 
    mkdir(data_directory); 
end
%cd(data_directory);

%select path for wave_clus
disp('Select the path for wave_clus'); %this one could be hardcoded?
waveclus = uigetdir();
addpath(genpath(waveclus));
%define matrix for storing all outputs
allClusters = cell(1,number_channels);
cd(data_directory);
%Opening file and saving individual .mat channels to be open by wav_clus
file=dir([pathbin filename]);
row_length=file.bytes/number_channels;
index = (0:row_length-1)/sr; %#ok<NASGU>
fid=fopen([pathbin filename],'r');
for n=1:number_channels
    data=fread(fid,[1,row_length],'*int16'); %Reads one row of the file and advances pointer %#ok<NASGU>
    name = strcat(filename(1:end-4), '_channel', num2str(n)); ext = '.mat';
    %save .mat file
    save([data_directory slash name ext], 'data', 'index', 'sr');
    %make cell with name of files to use
    file = {[name ext]};
    disp(['Processing channel ', num2str(n), ' of ', num2str(number_channels)]);
    %Get spikes
    Get_spikes(file, 'par', param, 'parallel', true);
    %outputs filename_spikes.mat
    %get clusters
    Do_clustering(strcat(name, '_spikes', ext), 'parallel', true);
    %load clustering results
    load(strcat('times_', name, ext));
    %add clustering results to all matrix
    allClusters{n} = cluster_class;
    clear data name 
end
disp('Saving final data matrix...');
save(strcat('clusters_', filename), 'allClusters');
disp('Done!');
end