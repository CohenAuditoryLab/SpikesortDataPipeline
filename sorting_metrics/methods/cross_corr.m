%% Cross Correlograms
    % initialize variables
    max_lag = 50e-3;
    lag_units = max_lag/bin_size;
    bootstrap_num = 100;
    num_clusters_for_corr = size(spikes_by_bin,1);
    %start loop
    disp('Generating pair-wise cross-correlograms.');
    parfor_progress(num_clusters_for_corr);
    avg_diff_array = zeros(num_clusters_for_corr,num_clusters_for_corr);
    half_matrix = triu(ones(num_clusters_for_corr,num_clusters_for_corr));
    parfor k=1:num_clusters_for_corr
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
%             acor_diff = zeros(bootstrap_num,1);
%             for i=1:bootstrap_num
%                  cell2_data_rand = cell2_data(randperm(length(cell2_data)));
%                  [x_coeff2, lag] = xcorr(cell1_data, cell2_data_rand, max_lag/bin_size, 'coeff');
%                  acor_diff(i) = mean(abs(x_coeff/max(x_coeff)-x_coeff2/max(x_coeff))); % difference normalized to max normal x_coeff
%             end;
%             avg_diff = mean(abs(acor_diff));
%             avg_diff_array(k,j) = avg_diff;
             %fprintf(['\n' num2str(k) '&' num2str(j) '\n']);
            
            % plot correlogram
            % make crosscorr directory 
            xcorr_directory = [new_directory slash 'cross_correlograms'];
            if 7~=exist(xcorr_directory, 'dir') mkdir(xcorr_directory); end
            f = figure('Position',[-1000,-1000,800,500]);
            %f = figure;
            plot(lag, x_coeff);
            title(['Cross Correlelogram' char(10) '(Cell ' num2str(active_clusters(k)) ' vs. Cell ' num2str(active_clusters(j)) ')']);
            a3 = gca;
            a3.XTickLabel = a3.XTick*5;
            xlabel('Lag (ms)');
            ylabel('R value');
            saveas(f,[xcorr_directory slash 'xcorr_' num2str(active_clusters(k)) '_' num2str(active_clusters(j)) '.png']);
            close all;
            
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
%     h = heatmap(avg_diff_array, active_clusters, active_clusters,[], 'Colorbar', 'true', 'ShowAllTicks', true);
%     title('Mean Difference between XCorr & XCorr with Bootstrapped Cell 2');
%     xlabel('Clusters'); ylabel('Clusters');
%     saveas(h, [new_directory slash 'xcorr__diff_with100randomcell2.png']);
%     disp('Saved Difference between XCorr & XCorr with Bootstrapped Cell 2.');
%     close all;