% set paths
origin = 'D:\SpikeSortingPipeline\Tanks';
temp = 'D:\SpikeSortingPipeline\ToSort';
dest = 'D:\SpikeSortingPipeline\Sorted';

% convert all tanks
convertTanks(origin,temp);

% spike sorting
files = dir(temp);
files = files([files.isdir]);
files = files(3:end);
for i = 1:length(files)
    f = files(i).name;
    movefile(fullfile(temp,f),dest);

    matToKiloSort(fullfile(dest,f,[f '.dat']), ...
        fullfile(dest,f,'KiloSort'), 96);
    sorting_metrics(fullfile(dest,f,'KiloSort'), ...
        'kilo', fullfile(dest,f,'Metrics','KiloSort'));
end
