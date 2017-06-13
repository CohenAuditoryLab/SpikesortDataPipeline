function mat2waveclus

path = uigetdir();
load(path);

%define data
data_temp = data.streams.NRaw.data;
sr = data.streams.NRaw.fs;
index = data.snips.eBxS.ts;
data = data_temp;
param.channels = size(data_temp, 1);

%save to mat file
name = 'eBxS_to_wave_clus';
ext = '.mat';
save(strcat(name, ext), 'data', 'index', 'sr', 'param');

%make cell with name of files to use 
file = {strcat(name, ext)};

%get spikes 
Get_spikes(file, 'par', param);

%outputs filename_spikes.mat
%get clusters 
Do_clustering(strcat(name, '_spikes', ext));

%eventual output is times_filename.mat

end