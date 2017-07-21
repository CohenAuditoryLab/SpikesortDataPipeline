%% BIN DATA
    % By Matt Schaff, matthew.schaff@gmail.com
     % Convert data into spikes by bin by cluster(cell)
        % intialize variables
        bin_size = 1e-3; % in seconds
        max_time = double(max(spike_times))/time_divisor;
        num_bins = round(max_time/bin_size) + 1; % add a bin to be safe
        %loop
        spikes_by_bin = [];
        disp(['Binning cluster spike times by ' num2str(bin_size*1000) 'ms bins.']);
        cluster_names = sort(unique(spike_clusters));
        num_clusters = numel(cluster_names);
        parfor_progress(num_clusters);
        cluster_count = zeros(num_clusters,1);
        parfor i = 1:num_clusters % 1 to num clusters
            % get spike times of the cell
            cluster_spikes = double(spike_times(find(spike_clusters==cluster_names(i))))./time_divisor; % now in seconds
            cluster_count(i) = numel(cluster_spikes);
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
        spikes_by_bin = spikes_by_bin(find(cluster_count>0), :);
        active_clusters = cluster_names(find(cluster_count>0));
        num_active_clusters = numel(active_clusters);
        parfor_progress(0);
        % save binned spikes
        save([new_directory slash 'binned_spikes_by_cluster.mat'], 'spikes_by_bin');
        disp('Saved binned spikes by cluster.');