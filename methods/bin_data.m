%% BIN DATA
    % By Matt Schaff, matthew.schaff@gmail.com
     % Convert data into spikes by bin by cluster(cell)
        % intialize variables
        bin_size = 1e-3; % in seconds
        max_time = double(max(spike_times))/double(sampling_rate);
        num_bins = round(max_time/bin_size) + 1; % add a bin to be safe
        %loop
        spikes_by_bin = [];
        disp(['Binning cluster spike times by ' num2str(bin_size*1000) 'ms bins.']);
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
        num_active_clusters = numel(active_clusters);
        parfor_progress(0);
        % save binned spikes
        save([new_directory slash 'binned_spikes_by_cluster.mat'], 'spikes_by_bin');
        disp('Saved binned spikes by cluster.');