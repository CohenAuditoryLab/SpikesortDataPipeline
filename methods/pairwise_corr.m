%% 0 lag pair-wise correlation matrix with a threshold
    %  false positives & negatives
    %  max R with a sliding lag, max lag 50 ms
    %  questionable sorting if high R at close to 0 ms lag
    disp('Computing 0-lag pair-wise correlation matrix.');
    n = size(spikes_by_bin',2);
    [A,p] = corrcoef(spikes_by_bin');
    % save significant correlations figure
    [row,col] = find(triu(p,1) < 0.05 & triu(p,1) ~=0);
    row_col = unique(sort(horzcat(row,col)), 'rows');
    idx = sub2ind(size(A), row_col(:,1), row_col(:,2));
    ylabels = strcat(num2str(active_clusters(row_col(:,1))),'&',num2str(active_clusters(row_col(:,2))));
    g = heatmap(A(idx), [], ylabels, A(idx), 'Colorbar', 'true', 'ShowAllTicks', true); 
    %a = gca; a.YTick = 1:numel(row);
    ylabel('Clusters'); xlabel('Pearson R value');
    title([num2str(numel(row_col(:,1))) ' Significant Pair-Wise 0-Lag Correlations (p<.05)']);
    saveas(g, [new_directory slash 'pairwisecorr_0lag_sig.png']);
    close all;
    % save general pairwise matrix figure
     p(p >= 0.05) = 0;
    p(1:length(p)+1:numel(p)) = 0;
    p = round(p, 4);
    A(1:n+1:n*n) = 0;
    h = heatmap(A, active_clusters, active_clusters,p, 'Colorbar', 'true', 'ShowAllTicks', true);
    title('0 Lag Pair-Wise Correlation Matrix'); xlabel('Clusters'); ylabel('Clusters');
    saveas(h, [new_directory slash 'pairwisecorr_0lag.png']);
    disp('Saved 0 lag pair-wise correlation matrix.');
    close all;