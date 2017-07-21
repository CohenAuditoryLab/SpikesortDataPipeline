function graphSpikes(fpath,rez)
%graphSpikes  Create a four graph grid of waveform data for provided clusters.
%   graphSpikes() prompts the user to select a rez file and will
%   display user-selected cluster grids. Used for viewing graphs only.
%   
%   graphSpikes(fpath) prompts the user to select a rez file and saves all
%   generated cluster grids to fpath. Used for manual generation of graphs.
%   
%   graphSpikes(fpath,rez) uses the provided rez file to create cluster
%   grids and saves them to fpath. Used for generation of graphs
%   automatically after running KiloSort.

%% initialize variables and extract spikes

if nargin < 2
    [fname,path] = uigetfile('D:\SpikeSortingPipeline\Sorted\*.mat','Select a rez file');
    load(fullfile(path,fname),'rez');
end
if nargin < 1
    display = 1;
else
    display = 0;
    cd(fpath);
end

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

if display % user selects cluster to graph
    figClust = figure('Name','View by Cluster','NumberTitle','off');
    set(gcf,'pos',[400 200 1000 600]);
    uicontrol('Style','listbox','Position',[10,10,50,200],'String',num2str(clusters-1),...
        'Callback',@(src,event) createClusterGrid(figClust,out,param,clusters(event.Source.Value)));
else % graph and save all clusters
    for i = 1:size(clusters)
        clustNum = clusters(i);
        fig = figure();
        set(gcf,'pos',[400 200 1000 600]);
        createClusterGrid(fig,out,param,clustNum);
        saveas(fig,['cluster_',num2str(clustNum-1),'.png']);
        close(fig);
    end
end

end
