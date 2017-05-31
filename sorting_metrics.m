function sorting_metric_output = sorting_metrics()
% Generates fidelity metrics for pre-sorted spikes
    % handle slashes
        if(ispc)
            slash = '\';
        else
            slash = '/';
        end
    % add npy
        addpath('npy-matlab');
    % Load Data from .npy files
        h = msgbox('Select the folder that contains the KiloSort *.npy output files');
        pause(1.5);
        delete(h);
        data_directory = uigetdir();
        spike_times = readNPY([data_directory slash 'spike_times.npy']);
        spike_clusters = readNPY([data_directory slash 'spike_clusters.npy']);
     % Load rez.mat
        load([data_directory slash 'rez.mat']);
        sampling_rate = rez.ops.fs; % in Hz
        disp(sampling_rate);
     % Convert data into spikes by bin by cluster(cell)
        % intialize variables
        bin_size = 5e-3; % milliseconds
        max_time = double(max(spike_times))/double(sampling_rate);
        num_bins = round(max_time/bin_size) + 1; % add a bin to be safe
        %loop
        spikes_by_bin = [];
        disp('Binning cluster spike times by 5 ms bins.');
        parfor_progress(max(spike_clusters));
        clusters = zeros(max(spike_clusters),1);
        parfor i = 1:max(spike_clusters) % 1 to num clusters
            % get spike times of the cell
            cluster_spikes = double(spike_times(find(spike_clusters==i)))./double(sampling_rate); % now in seconds
            clusters(i) = numel(cluster_spikes);
            if numel(cluster_spikes) == 0
                continue;
            end
            % collect by bin
            parfor_progress;
            for j=1:num_bins
                bin = j*bin_size;
                bin_prev = (j-1)*bin_size;
                spikes_by_bin(i,j) = numel(cluster_spikes(cluster_spikes <= bin & cluster_spikes > bin_prev));
            end    
        end
        spikes_by_bin = spikes_by_bin(find(clusters>0), :);
        active_clusters = find(clusters>0);
        parfor_progress(0);
        save('spikes_by_bin.mat', 'spikes_by_bin');
%% Cross-correlation matrix with a threshold
        %  false positives & negatives
        %  max R with a sliding lag, max lag 50 ms
        %  questionable sorting if high R at close to 0 ms lag
        disp(size(spikes_by_bin'));
        n = size(spikes_by_bin',2);
        [A,p] = corrcoef(spikes_by_bin');
         p(p >= 0.05) = 0;
        p(1:length(p)+1:numel(p)) = 0;
        p = round(p, 4)
        A(1:n+1:n*n) = 0;
        heatmap(A, active_clusters, active_clusters,p, 'Colorbar', 'true', 'ShowAllTicks', true);
        [row,col,v] = find(p~=0);
        % Generate cross corr matrix
    %% Refractory period violations vector (ISI)
        %   add up each time ISIs are below the absolute refractory period (3 ms)
        %   compute fractional level of contamination

    %% Autocorrelation; false positive matrix
        %   false positive matrix
        %   measure size of valley; DeWeese says good neurons have big valleys
        %   smooth with gaussian & measure with width at half max

end
