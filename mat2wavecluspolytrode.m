function mat2wavecluspolytrode

path = uigetdir();
load(path);

%data is opened 
temp_data = data.streams.NRaw.data;
index = data.snips.eBxS.ts;
sr = data.streams.NRaw.fs;
param.channels = size(temp_data, 1);

%save to mat file
data = temp_data(1,:);
save('polytrode1.mat', 'data', 'index', 'sr');
data = temp_data(2,:);
save('polytrode2.mat', 'data', 'index', 'sr');
data = temp_data(3,:);
save('polytrode3.mat', 'data', 'index', 'sr');
data = temp_data(4,:);
save('polytrode4.mat', 'data', 'index', 'sr');

%make .txt file with name of files to use 
fileID = fopen('polytrode1.txt','w');
fprintf(fileID, strcat('polytrode1.mat', '\n', 'polytrode2.mat', '\n', ...
    'polytrode3.mat', '\n', 'polytrode4.mat'));

%get spikes 
Get_spikes_pol(1, 'par', param);

%outputs filename_spikes.mat
%get clusters 
Do_clustering(1);

end