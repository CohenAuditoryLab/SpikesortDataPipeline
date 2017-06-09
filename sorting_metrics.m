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
        % save binned spikes
        new_directory = [data_directory slash 'sorting_fidelity_metrics'];
        if 7~=exist(new_directory, 'dir')
            mkdir(new_directory);
        end
        save([new_directory slash 'binned_spikes_by_cluster.mat'], 'spikes_by_bin');
        disp('Saved binned spikes by cluster.');
%% 0 lag pair-wise correlation matrix with a threshold
        %  false positives & negatives
        %  max R with a sliding lag, max lag 50 ms
        %  questionable sorting if high R at close to 0 ms lag
        n = size(spikes_by_bin',2);
        [A,p] = corrcoef(spikes_by_bin');
         p(p >= 0.05) = 0;
        p(1:length(p)+1:numel(p)) = 0;
        p = round(p, 4);
        A(1:n+1:n*n) = 0;
        h = heatmap(A, active_clusters, active_clusters,p, 'Colorbar', 'true', 'ShowAllTicks', true);
        title('0 Lag Pair-Wise Correlation Matrix'); xlabel('Clusters'); ylabel('Clusters');
        saveas(h, [new_directory slash 'pairwisecorr_0lag.png']);
        disp('Saved 0 lag pair-wise correlation matrix.');
        close all;
%% Cross Correlograms
    % initialize variables
    max_lag = 50e-3;
    lag_units = max_lag/bin_size;
    bootstrap_num = 100;
    num_clusters = size(spikes_by_bin,1);
    %start loop
    disp('Calculating pair-wise xcorr & comparing them to bootstrapped xcorr.');
    parfor_progress(num_clusters);
    avg_diff_array = zeros(num_clusters,num_clusters);
    half_matrix = triu(ones(num_clusters,num_clusters));
    parfor k=1:num_clusters
        cell1_data = spikes_by_bin(k, :);
        for j=1:num_clusters
            if k==j
                continue;
            end
            % make sure i haven't seen this combo before
            if half_matrix(j,k) > 0
               continue;
            end
            cell2_data = spikes_by_bin(j, :);
            %compute cross-correlelogram
            [x_coeff, lag] = xcorr(cell1_data, cell2_data, lag_units, 'coeff');

            % generate bootstrapped shuffled cell 2
            acor_diff = zeros(bootstrap_num,1);
            for i=1:bootstrap_num
                 cell2_data_rand = cell2_data(randperm(length(cell2_data)));
                 [x_coeff2, lag] = xcorr(cell1_data, cell2_data_rand, max_lag/bin_size, 'coeff');
                 acor_diff(i) = mean(abs(x_coeff/max(x_coeff)-x_coeff2/max(x_coeff))); % difference normalized to max normal x_coeff
            end;
            avg_diff = mean(abs(acor_diff));
            avg_diff_array(k,j) = avg_diff;
            fprintf ('/n');
            fprintf([num2str(k) '&' num2str(j) ': ' num2str(avg_diff) ' ']);
        %     plot(lag, x_coeff);
        %     title(['Cross Correlelogram' char(10) '(Cell ' num2str(cell1) ' vs. Cell ' num2str(cell2) ')']);
        %     a3 = gca;
        %     a3.XTickLabel = a3.XTick*5;
        %     xlabel('Lag (ms)');
        %     ylabel('R value');

        %     hold on;
        %     plot(lag, x_coeff2);
        %     title(['Cross Correlelogram' char(10) '(Cell ' num2str(cell1) ' vs. Cell ' num2str(cell2) ')']);
        %     a3 = gca;
        %     a3.XTickLabel = a3.XTick*5;
        %     xlabel('Lag (ms)');
        %     ylabel('R value');
        %     legend('Original Data', 'Shuffled Cell2 data');
        %     hold off;
        end
        parfor_progress;
    end
    parfor_progress(0);
    %save figure
    h = heatmap(avg_diff_array, active_clusters, active_clusters,[], 'Colorbar', 'true', 'ShowAllTicks', true);
    title('Mean Difference between XCorr & XCorr with Bootstrapped Cell 2');
    xlabel('Clusters'); ylabel('Clusters');
    saveas(h, [new_directory slash 'xcorr__diff_with100randomcell2.png']);
    disp('Saved Difference between XCorr & XCorr with Bootstrapped Cell 2.');
    close all;
%% Refractory period violations vector (ISI)
    %   add up each time ISIs are below the absolute refractory period (3 ms)
    %   compute fractional level of contamination
        %initialize variables
            refractory_limit = 3e-3;
            violations = [];
        %loop through clusters
            for i=1:max(spike_clusters)
                %get spike times in cluster
                    cluster_spikes = double(spike_times(find(spike_clusters==i)))./double(sampling_rate); % now in seconds
                    clusters(i) = numel(cluster_spikes);
                    if clusters(i) == 0
                        violations(i) = -1; %gonna take these out later
                        continue;
                    end
                %set violations = 0 if there's only 1 spike
                    if clusters(i) < 2
                        violations(i) = 0;
                        continue;
                    end
                % set violations by looping through spikes
                    violation_counter = 0;
                    for k=2:clusters(i)
                        % add to violation counter if the second spike is
                        % less than refractory period limit
                        if cluster_spikes(k) - cluster_spikes(k-1) < refractory_limit
                            violation_counter = violation_counter + 1;
                        end
                    end
                    violations(i) = violation_counter;
            end
            %output zscore bar graph
            violations = violations(find(violations>-1))';
            clusters = clusters(find(clusters>0))';
            violations_per_event_rate = violations./clusters';
            violations_per_event_rate_z = zscore(violations_per_event_rate);
            close all;
            figure;
            f = bar(violations_per_event_rate_z);
            a = gca; a.XTick = 1:30;
            axis([0 numel(violations) 0 inf]);
            xlabel('Clusters');
            xticklabels(active_clusters);
            ylabel('ISI Violation/Event (+ZScores)');
            title('ISI Refractory Violations per Event (only + ZScores)');
            saveas(f, [new_directory slash 'isi__refractory_violations_per_event.png']);
            disp('Saved ISI violations per event.');
            %close all;
    %% Autocorrelation; false positive matrix
        %   false positive matrix
        %   measure size of valley; DeWeese says good neurons have big valleys
        %   smooth with gaussian & measure with width at half max
        
        % initialize variables
            max_lag = 50e-3;
            lag_units = max_lag/bin_size;
        % make auto directory 
        auto_directory = [new_directory slash 'autocorrelations'];
        if 7~=exist(auto_directory, 'dir')
            mkdir(auto_directory);
        end
        % loop through active clusters
            disp('Generating autocorrelograms for clusters.');
            parfor_progress(numel(active_clusters));
            parfor i=1:numel(active_clusters)
                % generate autocorrelogram per active cluster
                cell_data = spikes_by_bin(i, :);
                [x_coeff, lag] = xcorr(cell_data, cell_data, lag_units, 'coeff');
                x_coeff(numel(x_coeff)/2+0.5) = 0; %replace lag of 0 with value of 0 instead of 1
                 figure;
                 f = plot(lag, x_coeff);
                 title(['AutoCorrelelogram' char(10) '(Cluster ' num2str(active_clusters(i)) ')']);
                 a3 = gca;
                 a3.XTickLabel = a3.XTick*5;
                 xlabel('Lag (ms)');
                 ylabel('R value');
                 xlim([1 10]);
                 xticklabels(5:5:50);
                 saveas(f, [auto_directory slash ['autocorr_cluster' num2str(active_clusters(i)) '.png']]);
                 close all;
                 %NOTE: I must come up with a way of measuring the width of
                 %the valley in autocorrelograms!!!
                 
                 % difference between autocorr of 1st half & 2nd half
                 first_half = cell_data(1:round(numel(cell_data)/2));
                 second_half = cell_data(round(numel(cell_data)/2)+1:end);
                 [first_coeff, lag] = xcorr(first_half, first_half, lag_units, 'coeff');
                 [second_coeff, lag] = xcorr(second_half, second_half, lag_units, 'coeff');
                 autocorr_diff(i) = sum((first_coeff - second_coeff).^2) % sum of squared difference
                 parfor_progress;
            end
            parfor_progress(0);
            
            %save autocorr diff figure
            f = bar(autocorr_diff);
            axis([0 numel(autocorr_diff) 0 inf]);
            a = gca; a.XTick = 1:30;xticklabels(active_clusters);
            xlabel('Clusters');
            ylabel('Sum Squared Difference between 1st & 2nd Half Autocorrelation');
            title('Sum Squared Difference between 1st & 2nd Half Autocorrelation');
            saveas(f, [new_directory slash 'autocorr_diff_halves.png']);
            
            disp('Saved cluster autocorrelograms.');
        
 %% avg firing rate changing over time
 
end
