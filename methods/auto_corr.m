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
                 autocorr_diff(i) = sum((first_coeff - second_coeff).^2); % sum of squared difference
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