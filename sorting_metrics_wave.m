function sorting_metric_output = sorting_metrics_wave()
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
        sampling_rate = 1e3;
        disp(sampling_rate);
     % Convert data into spikes by bin by cluster(cell)
        % intialize variables
        bin_size = 1e-3; % in seconds
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
        num_active_clusters = numel(active_clusters);
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
            violations = zeros(max(spike_clusters),1);
            clusters = zeros(max(spike_clusters),1);
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
                % output ISI distribution
                g = figure;
                histogram(diff(cluster_spikes), 'BinWidth', 0.001, 'BinLimits', [0 0.1]);
                yticks = get(gca,'YTick'); yticks = yticks(find(yticks==floor(yticks)));
                set(gca, 'YTick', yticks);
                set(gca, 'XTickLabel', 0:10:100);
                title('ISI Distribution to 100 ms'); ylabel('Number of Occurrences'); xlabel('ISI (ms)');
                % make ISI
                isi_directory = [new_directory slash 'isi_distributions'];
                if 7~=exist(isi_directory, 'dir') mkdir(isi_directory); end
                saveas(g, [isi_directory slash 'isi__distribution_' num2str(active_clusters(i)) '.png']); close all;
            end
            disp('Saved ISI distributions.');
            close all;
            %output bar graph
            violations = violations(find(violations>-1))';
            clusters = clusters(find(clusters>0))';
            violations_per_event_rate = violations./clusters;
            %violations_per_event_rate_z = zscore(violations_per_event_rate);
            close all;
            figure;
            f = bar(violations_per_event_rate);
            a = gca; a.XTick = 1:num_active_clusters;
            axis([0 numel(violations) 0 inf]);
            xlabel('Clusters');
            xticklabels(active_clusters);
            ylabel('ISI Violations/Spikes');
            title('ISI Refractory Violations per Spike Rate');
            saveas(f, [new_directory slash 'isi__refractory_violations_per_spike.png']); close all;
            disp('Saved ISI violations per spike rate.');
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
            avg_valley_r = zeros(numel(active_clusters),1);
            autocorr_diff = zeros(numel(active_clusters),1);
            parfor i=1:numel(active_clusters)
                % generate autocorrelogram per active cluster
                cell_data = spikes_by_bin(i, :);
                [x_coeff, lag] = xcorr(cell_data, cell_data, lag_units, 'coeff');
                x_coeff(numel(x_coeff)/2+0.5) = 0; %replace lag of 0 with value of 0 instead of 1
                 figure;
                 f = plot(lag, x_coeff);
                 title(['AutoCorrelelogram' char(10) '(Cluster ' num2str(active_clusters(i)) ')']);
                 a3 = gca;
                 xticklabels(0:bin_size*1000:max_lag*1000);
                 a3.XTickLabel = a3.XTick*bin_size*1000;
                 xlabel('Lag (ms)');
                 ylabel('R value');
                 xlim([0 lag_units]);
                 %
                 saveas(f, [auto_directory slash ['autocorr_cluster' num2str(active_clusters(i)) '.png']]);
                 close all;
                 %Assess the valley in autocorrelograms
                 middle_coeff = numel(x_coeff)/2+0.5;
                 avg_valley_r(i) = mean(x_coeff(middle_coeff+1:middle_coeff+5));
                 
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
            figure;
            f = bar(autocorr_diff);
            axis([0 numel(autocorr_diff) 0 inf]);
            a = gca; a.XTick = 1:num_active_clusters;xticklabels(active_clusters);
            xlabel('Clusters');
            ylabel('Sum Squared Difference between 1st & 2nd Half Autocorrelation');
            title('Sum Squared Difference between 1st & 2nd Half Autocorrelation');
            saveas(f, [new_directory slash 'autocorr_diff_halves.png']); close all;
            
            %save avg valley R figure 
            figure;
            f = bar(avg_valley_r);
            axis([0 numel(avg_valley_r) 0 inf]);
            a = gca; a.XTick = 1:num_active_clusters;xticklabels(active_clusters);
            xlabel('Clusters');
            ylabel('Avg AutoCorr Valley R Value');
            title('Average AutoCorrelation R Value of Lag <= 5ms');
            saveas(f, [new_directory slash 'autocorr__autocorr_valley_r.png']); close all;
            disp('Saved cluster autocorrelograms.'); 
        
 %% drift measure: slope of firing rate (over 30s) over session
    % bin spikes by minute
    firing_window = 30; % seconds
    num_small_bins = 1/bin_size*firing_window;
    num_windows = floor(size(spikes_by_bin,2)/num_small_bins);
    firing_rates = zeros(size(spikes_by_bin,1), num_windows);
    line_slopes = zeros(1,num_active_clusters);
    cluster_curve = zeros(num_active_clusters);
    x = firing_window:firing_window:num_windows*firing_window;
    h = figure; hold on;
    for k=1:size(spikes_by_bin,1) %loop through cells
        for i=1:num_windows
            firing_rates(k,i) = sum(spikes_by_bin(k,(i-1)*num_small_bins+1:i*num_small_bins))/firing_window; % in Hz
        end
        %fit line
        P = polyfit(x,firing_rates(k,:),1);
        line_slopes(k) = P(1);
         cluster_curve(k) = plot(x,firing_rates(k,:));
         disp(cluster_curve(k));
         yfit = P(1)*x+P(2);
         plot(x,yfit,'r-.');
    end
    g = legend(cluster_curve(:,1),num2str(active_clusters));
    set(g, 'Location', 'northeast');
    xlabel('Seconds');
    ylabel('Firing Rate');
    title('Firing Rate of Clusters over Time');
    hold off;
    saveas(h, [new_directory slash 'drift__frate.png']);
    close all;
    f = figure;
    bar(line_slopes);
    a = gca; a.XTick = 1:num_active_clusters;xticklabels(active_clusters);
    xlabel('Clusters');
    ylabel('Slope of Firing Rate over Time (Hz/s)');
    title('Slope of Firing Rate over Time (30s bins)');
    saveas(f, [new_directory slash 'drift__frate_slope.png']);
    close all;
% end
