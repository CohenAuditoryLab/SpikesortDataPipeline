function outputCollector = runMetricsOnMultipleOutputs(sampling_rate, just_isi)
    % get output and target directories
    disp('Select or create an output directory for the sorting metrics summary.');
    outputDir = uigetdir;
    disp('Select Kilosort output directories');
    files = uigetfile_n_dir();
    % initialize variables
    data_type = 'kilo';
    if exist('sampling_rate', 'var') == 0 || sampling_rate == 0
        sampling_rate = 24414;
    end
    if exist('just_isi', 'var') == 0
        just_isi = 0;
    end
    % handle slashes
    if(ispc)
        sslash = '\';
    else
        sslash = '/';
    end
    % run sorting metrics & collect output
    outputCollector = [];
    for i=1:numel(files)
    % loop through the directores
        output = struct;
        [~,output.fileName,~] = fileparts(files{1});
        % run sorting metrics
        sorting_metrics(files{i}, data_type, [files{i} sslash 'Metrics'], sampling_rate,just_isi);
        % count cluster # 
        images = dir([files{i} sslash 'Metrics' sslash 'isi_distributions']);
        output.numClusters = numel(images) - 2; % because dir also produces '.' and '..'
        % count violation #s
        load([files{i} sslash 'Metrics' sslash 'violators.mat']);
        output.numGreaterThan30PercentViolations = numel(violators.greaterThan_30);
        % add to collector variable
        outputCollector = [outputCollector; output];
    end
    % save collector variable
    struct2csv(outputCollector, [outputDir sslash 'SortingMetricsSummary.csv']);
    disp('Completed sorting metrics & saved summary.');
end