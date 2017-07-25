function convertTanks(fpath,save_path)
%convertTanks Converts all unconverted tanks in a specified folder.
%   fpath: folder where unconverted tanks are stored
%   save_path: folder to store converted binaries

% path to csv file containing list of converted experiment/block pairs
csv_path = 'D:\SpikeSortingPipeline\Code\SAM_master_completed.csv';
% path to xls file containing background info for each experiment/block pair
xls_path = 'D:\SpikeSortingPipeline\Tanks\SAM_master_list.xlsx';

% read master lists
[~,~,raw] = xlsread(xls_path);
completed = csvread(csv_path,1);

% go through all experiments using the correlative from master list
for exp = 15:max(cell2mat(raw(:,1)))
    indices = find(cell2mat(raw(:,1)) == exp); % get block indices for experiment
    diff = setdiff(1:length(indices),completed((completed(:,1) == exp),2));
    indices = indices(diff); % remove completed blocks
    for block = 1:length(indices) % convert each block
        index = indices(block);
        tankfile = char(cell2mat(raw(index,4)));
        forigin = fullfile(fpath,tankfile);
        fdest = fullfile(save_path,tankfile);
        blocknum = cell2mat(raw(index,6));
%         numchannels = cell2mat(raw(index,8));
        getting_tank_data(forigin, blocknum, 'xpz2', 96, 1, 1, 1, ...
            [fdest '_b' num2str(blocknum) '_AL']);
        getting_tank_data(forigin, blocknum, 'xpz5', 96, 1, 1, 1, ...
            [fdest '_b' num2str(blocknum) '_ML']);
        dlmwrite(csv_path,[exp block],'-append','delimiter',',');
    end
end
end
