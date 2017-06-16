function mat2wavecluspolytrode(filename)
disp('Select the path for your .mat data');
path = uigetdir();
cd(path);

disp(['Loading ' filename]);
load(filename);

%define data
data_temp = spikes;
r = size(data_temp, 1);

%select path for wave_clus
disp('Select the path for wave_clus');
waveclus = uigetdir();
cd(waveclus);

% define sampling rate, timestamps, and parameters
sr = fs;
index = (0:size(data_temp,2)-1)/sr;
param.stdmin = 3.5; 
param.segments_length = 10;
param.to_plot_std = 2;
param.detect_fmax = 7000;

%make .txt file with name of files to use 
fileID = fopen('polytrode1.txt','w');

for n = 1:r
%     disp(['Creating data file for channel ', num2str(n), ' of ', num2str(r)]);
%     
%     data = data_temp(n, :);
%     
     name = strcat(filename, '_channelPOLY', num2str(n));
     ext = '.mat';
%     
%     %save .mat file
%     save(strcat(name, ext), 'data', 'index', 'sr');
    disp(['Printing data file for channel ', num2str(n), ' of ', num2str(r)]);
    fprintf(fileID, strcat(name, ext, '\n'));
end

%make sure wave_clus is in the path
addpath(genpath('/media/Data_Store/wave_clus/MATLAB/wave_clus-testing'))

disp('Getting spikes...');
%get spikes 
Get_spikes_pol(1, 'par', param);

disp('Clustering...');
%outputs filename_spikes.mat
%get clusters 
Do_clustering(1);

end