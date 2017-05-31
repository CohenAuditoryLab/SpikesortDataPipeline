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
        data_directory = uigetdir()
        spike_times = readNPY([data_directory slash 'spike_times.npy']);
        spike_clusters = readNPY([data_directory slash 'spike_clusters.npy']);
     % Convert data into spikes by bin by cluster(cell)
        for i = 1:max(spike_clusters) % 1 to num clusters
            % get spike times of the cell
            cluster_spikes = spike_times(find(spike_clusters==i));
            if numel(cluster_spikes) == 0
                continue;
            end
            disp(numel(cluster_spikes));
            % collect by bin
        end
%% Cross-correlation matrix with a threshold
        %  false positives & negatives
        %  max R with a sliding lag, max lag 50 ms
        %  questionable sorting if high R at close to 0 ms lag
        
        % Generate cross corr matrix
    %% Refractory period violations vector (ISI)
        %   add up each time ISIs are below the absolute refractory period (3 ms)
        %   compute fractional level of contamination

    %% Autocorrelation; false positive matrix
        %   false positive matrix
        %   measure size of valley; DeWeese says good neurons have big valleys
        %   smooth with gaussian & measure with width at half max

end
