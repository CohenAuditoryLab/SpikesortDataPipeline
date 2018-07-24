function graphSpikes_v2(fpath,rez)
%   Create a graph of waveform data for provided clusters.
%   graphSpikes_v2() prompts the user to select a rez file and will
%   save all cluster grids. Used for manual generation of graphs.
%
%   graphSpikes(fpath) loads the rez file located in fpath and saves all
%   generated cluster grids to fpath. Used for manual generation of graphs.
%
%   graphSpikes(fpath,rez) uses the provided rez file to create cluster
%   grids and saves them to fpath. Used for generation of graphs
%   automatically after running KiloSort.
%% initialize variables and extract spikes
if nargin < 1
    [fname,fpath] = uigetfile('D:\SpikeSortingPipeline\Sorted\*.mat','Select a rez file');
    load(fullfile(fpath,fname),'rez');
else
    if nargin < 2
        load(fullfile(fpath,'rez.mat'),'rez_merged');
    end
    
end
rez = rez_merged;
cd(fpath);
mkdir KiloSort_Images;
cd KiloSort_Images;

% time window to sample and display
param.sample_win = -35:35;
param.view_win = -25:25;

% extract spikes
out = getRawWaveforms1(rez,param.sample_win);
clusters = unique(out.spikeClusters);

% convert x-axis from samples to ms
param.samp_fac = 1000 / 24424;
param.sample_win_fac = param.sample_win * param.samp_fac;
param.view_win_fac = param.view_win * param.samp_fac;

% intitialize as spikeTime x waveform
param.peakSpikes = zeros(size(out.spikeWaves,3),size(out.spikeWaves,2));

% extract peak channel waveform from raw waveform data
for i = 1:size(out.spikeWaves,3)
    param.peakSpikes(i,:) = out.spikeWaves(out.peakChannel(i),:,i);
end

%% graphing controls
opacity = 0.1;

tic
for i = 1:size(clusters,1)
    clustNum = clusters(i);
    fig = figure();
    set(fig, 'Visible', 'off');
    set(gcf,'pos',[400 200 1000 600]);
    
    extractSpk = (clustNum == out.spikeClusters(:,1));
    spk = param.peakSpikes(extractSpk,:);
    
    % "raw data"
    subplot(1,3,1);
    cla;
    hold on;
    title(['Cluster ' num2str(clustNum-1) ': Raw Data']);
    axis([param.view_win_fac(1) param.view_win_fac(end) -inf inf]);
    xlabel('time since spike detection (ms)');
    
    plt = plot(param.sample_win_fac,spk,'r'); hold on;
    set(plt, 'Color', [1 0 0 opacity])
    plot(param.sample_win_fac,mean(spk),'k','LineWidth',3);
    
    % centered around min
    subplot(1,3,2);
    cla;
    hold on;
    title(['Cluster ' num2str(clustNum-1) ': Centered to Min']);
    axis([param.view_win_fac(1) param.view_win_fac(end) -inf inf]);
    xlabel('time since spike min (ms)');
    % intialize average matrix, first col is running total, second is number of entries
    min_avg = zeros(size(param.view_win,2),2);
    
    % centered around max
    subplot(1,3,3);
    cla;
    hold on;
    title(['Cluster ' num2str(clustNum-1) ': Centered to Max']);
    axis([param.view_win_fac(1) param.view_win_fac(end) -inf inf]);
    xlabel('time since spike max (ms)');
    % intialize average matrix, first col is running total, second is number of entries
    max_avg = zeros(size(param.view_win,2),2);
    
    xaxis_low = [];
    xaxis_high =[];
    for j = 1:(size(spk,1))
        y_axis = squeeze(spk(j,:));
        
        %shift graphs along x-axis
        [~,minInd] = min(y_axis);
        x_axis_min = param.sample_win_fac-param.sample_win_fac(minInd);
        xaxis_low(end+1, :) = x_axis_min;
        min_indices = param.view_win + minInd;
        [~,maxInd] = max(y_axis);
        x_axis_max = param.sample_win_fac-param.sample_win_fac(maxInd);
        xaxis_high(end+1, :) = x_axis_max;
        max_indices = param.view_win + maxInd;
        
        % update average waveform data
        for k = 1:size(param.view_win,2)
            if (min_indices(k) > 0) && (min_indices(k) < size(y_axis,2))
                min_avg(k,1) = min_avg(k,1) + y_axis(min_indices(k)); % add to running total
                min_avg(k,2) = min_avg(k,2) + 1; % added an element
            end
            if (max_indices(k) > 0) && (max_indices(k) < size(y_axis,2))
                max_avg(k,1) = max_avg(k,1) + y_axis(max_indices(k)); % add to running total
                max_avg(k,2) = max_avg(k,2) + 1; % added an element
            end
        end
    end
    
    subplot(1,3,2); hold on;
    plt = plot(xaxis_low, spk,'r');
    set(plt, 'Color', [1 0 0 opacity])
    subplot(1,3,3); hold on;
    plt = plot(xaxis_high,spk,'r');
    set(plt, 'Color', [1 0 0 opacity])
    
    subplot(1,3,2); hold on;
    plot(param.view_win_fac,rdivide(min_avg(:,1),min_avg(:,2)),'k','LineWidth',3);
    subplot(1,3,3); hold on;
    plot(param.view_win_fac,rdivide(max_avg(:,1),max_avg(:,2)),'k','LineWidth',3);
    
    saveas(fig,['cluster_',num2str(clustNum-1),'.png']);
    close(fig);
end

fprintf('graphSpikes took %2.2f minutes to run \n', floor(toc/0.6)/100);
end

