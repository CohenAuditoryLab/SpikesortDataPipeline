function sorting_metric_output = sorting_metrics_wave()
% Generates fidelity metrics for pre-sorted spikes
%% Set Up Tasks
    % handle slashes
        if(ispc)
            slash = '\';
        else
            slash = '/';
        end
    % add methods directory
        addpath([pwd slash 'methods']);
    % add npy
        addpath('npy-matlab');
    % Load Data
        h = msgbox('Select the the Wave_clus output file');
        pause(1.5);
        delete(h);

        [data_file, file_path] = uigetfile();
        data_directory = file_path;
        data = load([data_directory data_file]);
        spike_times = data.cluster_class(data.cluster_class(:,1) ~= 0,2); % get times of active clusters %readNPY([data_directory slash 'spike_times.npy']);
        spike_clusters = data.cluster_class(data.cluster_class(:,1) ~= 0,1); % get times of active clusters %readNPY([data_directory slash 'spike_clusters.npy']);
     % Load rez.mat
        %load([data_directory slash 'rez.mat']);
        %sampling_rate = rez.ops.fs; % in Hz
%% Bin Data
   bin_data;
%% 0 lag pair-wise correlation matrix with a threshold
   pairwise_corr;
%% Cross Correlograms
   cross_corr;
%% Refractory period violations vector (ISI)
   isi_violations;
%% Autocorrelation; false positive matrix
   auto_corr;
%% drift measure: slope of firing rate (over 30s) over session
   drift_fr;
end
