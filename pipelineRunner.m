% set paths
origin = 'D:\SpikeSortingPipeline\Tanks';
temp = 'D:\SpikeSortingPipeline\ToSort';
dest = 'D:\SpikeSortingPipeline\Sorted';

% convert all tanks
convertTanks(origin,temp);

% spike sorting
files = dir(temp);
files = files([files.isdir]);
for i = 1:length(files)
    move(fullfile(temp,files(i)),dest);
    
    % run KiloSort and WaveClus
    matToKiloSort(fullfile(dest,files(i),[files(i) '.dat']), ...
        fullfile(dest,files(i),'KiloSort'), 96);
    matToWaveClus(fullfile(dest,files(i),[files(i) '.dat']), ...
        fullfile(dest,files(i),'WaveClus'), 96);
    
    % run metrics
    sorting_metrics(fullfile(dest,files(i),'KiloSort'), ...
        'kilo', fullfile(dest,files(i),'Metrics','KiloSort'));
    sorting_metrics(fullfile(dest,files(i),'WaveClus','all_clusters.dat'), ...
        'wave', fullfile(dest,files(i),'Metrics','WaveClus'));
end
