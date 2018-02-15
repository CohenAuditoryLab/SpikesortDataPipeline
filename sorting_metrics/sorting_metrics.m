function sorting_metrics = sorting_metrics(data_dir_or_file, data_type, new_directory, sampling_rate, just_isi)
% Generates fidelity metrics for pre-sorted spikes
%% Set Up Tasks
    % check input parameters
    if exist('data_dir_or_file', 'var') == 0
        error('Sorted spike input directory or file is not set.');
    end
    if exist('new_directory', 'var') == 0 || 7~=exist(new_directory, 'dir')
        mkdir(new_directory);
    end
    if exist('data_type', 'var') == 0
        error('Data type - kilo or wave - must be set.');
    end
    if exist('sampling_rate', 'var') == 0 || sampling_rate == 0
        sampling_rate = 24414;
    end
    % introduction message
    fprintf(['Generating sorting quality metrics for the following data: \n' num2str(data_dir_or_file) '\n Data Type: ' data_type '\n \n']);
    % handle slashes
        if(ispc)
            slash = '\';
        else
            slash = '/';
        end
    % add methods directory
        addpath(genpath('methods'));
    % add libraries
        addpath(genpath('libraries'));
    % Load Data
        disp('Loading data');
        % wave
        if data_type == 'wave'
            data = load(data_dir_or_file);
            data_directory = fileparts(data_dir_or_file);
            %spike_times = data.cluster_class(data.cluster_class(:,1) ~= 0,2); % get times of active clusters %readNPY([data_directory slash 'spike_times.npy']);
            %spike_clusters = data.cluster_class(data.cluster_class(:,1) ~= 0,1); % get times of active clusters %readNPY([data_directory slash 'spike_clusters.npy']); 
            
            % Combine clusters from different wave_clus outputs
            g = [];
            for i=1:numel(data.allClusters)
                g = [g; data.allClusters{i}(data.allClusters{i}(:,1)~=0,1)./10.+i, data.allClusters{i}(data.allClusters{i}(:,1)~=0,2)];
            end
            spike_times = g(:,2);
            spike_clusters = g(:,1);
            time_divisor = 1e3; % bec wave_clus outputs in milliseconds, not seconds or sampling number (like kilosort)
        % kilo
        elseif data_type == 'kilo'
            data_directory = data_dir_or_file;
            spike_times = readNPY([data_directory slash 'spike_times.npy']);
            spike_clusters = readNPY([data_directory slash 'spike_clusters.npy']);
            time_divisor = double(sampling_rate);
        end
        disp('Data loaded.');
        % save standard cluster_spike_output
        standard_output = horzcat(spike_clusters, spike_times);
        disp('Standard cluster & spike output saved.');
        save([new_directory slash 'cluster_spike_output.mat'], 'standard_output');
    % turn off figure generation
        set(0,'DefaultFigureVisible','off');

%% Bin Data
    bin_data;
%% Refractory period violations vector (ISI)
    isi_violations;
    if exist('just_isi', 'var') == 1 && just_isi == 1 return, end
%% Cross Correlograms
    cross_corr;
%% 0 lag pair-wise correlation matrix with a threshold
    pairwise_corr;  
%% Autocorrelation; false positive matrix
    auto_corr;
%% drift measure: slope of firing rate (over 30s) over session
    drift_fr;
%% conclusion
    % turn on figure generation
     set(0,'DefaultFigureVisible','on');
     sorting_metrics = ['Sorting metrics complete. Output saved to: ' new_directory];
% end
