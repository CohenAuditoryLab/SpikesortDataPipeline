%% Refractory period violations vector (ISI)
    %   add up each time ISIs are below the absolute refractory period (3 ms)
    %   compute fractional level of contamination
        %initialize variables
            refractory_limit = 3e-3;
            violations = zeros(num_clusters,1);
            clusters = zeros(num_clusters,1);
        %loop through clusters
            disp('Computing ISI distributions & violations.');
            for i=1:num_clusters
                %get spike times in cluster
                    cluster_spikes = double(spike_times(find(spike_clusters==cluster_names(i))))./time_divisor; % now in seconds
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