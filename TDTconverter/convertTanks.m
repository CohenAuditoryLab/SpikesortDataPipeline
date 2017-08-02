function convertTanks(fpath,save_path)
%convertTanks Converts all unconverted tanks in a specified folder.
%   fpath: folder where unconverted tanks are stored
%   save_path: folder to store converted binaries

% path to csv file containing list of converted experiment/block pairs
csv_path = 'D:\SpikeSortingPipeline\Code\TDTconverter\SAM_master_completed.csv';
% path to xls file containing background info for each experiment/block pair
xls_path = 'D:\SpikeSortingPipeline\Tanks\SAM_master_list.xlsx';

exclude = [1:14 18]; % experiments to exclude from conversion

% read master lists
[~,~,raw] = xlsread(xls_path);
completed = csvread(csv_path,1);

% go through all experiments using the correlative from master list
for exp = 1:max(cell2mat(raw(:,1)))
    indices = find(cell2mat(raw(:,1)) == exp); % get block indices for experiment
    blocks = setdiff(1:length(indices),completed((completed(:,1) == exp),2));
    indices = indices(blocks); % remove completed blocks
    if ~any(exp == exclude)
        for i = 1:length(indices) % convert each block
            tic; % start clock
            index = indices(i); % index in xls file
            tankfile = char(cell2mat(raw(index,4)));
            block = cell2mat(raw(index,6));
            chan_num = cell2mat(raw(index,8));
            forigin = fullfile(fpath,tankfile);
            fdest = [fullfile(save_path,tankfile) '_b' num2str(block)];

            disp(['Working on ' tankfile ', block ' num2str(block) '...']);
            disp('Converting AL data... ');
            getting_tank_data(forigin, block, 'xpz2', chan_num, 1, 1, 1, ...
                [fdest '_AL']);
            disp('Converting ML data... ');
            getting_tank_data(forigin, block, 'xpz5', chan_num, 1, 1, 1, ...
                [fdest '_ML']);

            disp('Getting meta data... ');
            meta = tankMetaData(forigin, block, cell2mat(raw(index,7)), ...
                chan_num, fullfile(fpath,'LabVIEW',[cell2mat(raw(index,32)) '.mat'])); %#ok<NASGU>
            cd([fdest '_AL']);
            save('meta.mat','meta');

            disp(['Conversion took ' num2str(toc/60) ' minutes. Writing to csv file...']);
            dlmwrite(csv_path,[exp block],'-append','delimiter',',','newline', 'pc');
        end
    end
end
end
