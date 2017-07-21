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