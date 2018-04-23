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
        load(fullfile(fpath,'rez.mat'),'rez');
    end
    
end

cd(fpath);
mkdir KiloSort_Images;
cd KiloSort_Images;

% time window to sample and display
param.sample_win = -35:35;
param.view_win = -25:25;

% extract spikes
out = getRawWaveforms(rez,param.sample_win);
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

    cla;
    hold on;
    title(['Cluster ' num2str(clustNum-1) ': Raw Data']);
    axis([param.view_win_fac(1) param.view_win_fac(end) -inf inf]);
    xlabel('time since spike detection (ms)');
    
%     y_axis = squeeze(spk(i,:));
    plt = plot(param.sample_win_fac,spk,'r'); hold on;
%     plt(:).Color = repmat([1 0 0 opacity], size(spk, 1), 1);
%     plt.MarkerFaceAlpha = opacity;
    set(plt, 'Color', [1 0 0 opacity])
    plot(param.sample_win_fac,mean(spk),'k','LineWidth',3);
    
    saveas(fig,['cluster_',num2str(clustNum-1),'.png']);
    close(fig);
end
fprintf('graphSpikes took %2.2f minutes to run \n', floor(toc/0.6)/100);
end

