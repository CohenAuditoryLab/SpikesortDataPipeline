function mat2waveclus(filename)
%select path for data
disp('Select the path for your .mat data');
path = uigetdir();
cd(path);

disp(['Loading ' filename]);
load(filename);

%define data
data_temp = data.streams.NRaw.data;
r = size(data_temp, 1);
    
%select path for wave_clus
disp('Select the path for wave_clus');
waveclus = uigetdir();
cd(waveclus);

%define sampling rate
sr = data.streams.NRaw.fs;
index = data.snips.eBxS.ts;

%define matrix for storing all outputs
allClusters = cell(1,8);

for n = 1:r
    data = data_temp(n, :);
    
    name = strcat('channel', num2str(n));
    ext = '.mat';
    
    %save .mat file
    save(strcat(name, ext), 'data', 'index', 'sr');
    
    %make cell with name of files to use
    file = {strcat(name, ext)};
    
    disp(['Processing channel ', num2str(n), ' of ', num2str(r)]);
    
    %Get spikes 
    Get_spikes(file);
    %outputs filename_spikes.mat
    
    %get clusters
    Do_clustering(strcat(name, '_spikes', ext));
    
    %load clustering results
    load(strcat('times_', name, ext));
        
    %add clustering results to all matrix
    allClusters{n} = cluster_class;
end

disp('Saving final data matrix...');
save(strcat('clusters_', filename), 'allClusters');
disp('Done!');

end