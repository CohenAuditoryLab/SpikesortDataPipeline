function sorting_metric_output = sorting_metrics()
% Generates fidelity metrics for pre-sorted spikes

    %% Cross-correlation matrix with a threshold
        %  false positives & negatives
        %  max R with a sliding lag, max lag 50 ms
        %  questionable sorting if high R at close to 0 ms lag

    %% Refractory period violations vector (ISI)
        %   add up each time ISIs are below the absolute refractory period (3 ms)
        %   compute fractional level of contamination

    %% Autocorrelation; false positive matrix
        %   false positive matrix
        %   measure size of valley; DeWeese says good neurons have big valleys
        %   smooth with gaussian & measure with width at half max

end
