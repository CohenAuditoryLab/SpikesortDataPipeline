function graphSpikes(fpath,rez)
%graphSpikes  Create a four graph grid of waveform data for provided clusters.
%   graphSpikes() prompts the user to select a rez file and will
%   display user-selected cluster grids. Used for viewing graphs only.
%   
%   graphSpikes(fpath) loads the rez file located in fpath and saves all
%   generated cluster grids to fpath. Used for manual generation of graphs.
%   
%   graphSpikes(fpath,rez) uses the provided rez file to create cluster
%   grids and saves them to fpath. Used for generation of graphs
%   automatically after running KiloSort.

%% initialize variables and extract spikes

if nargin < 1
    display = 1;
    [fname,fpath] = uigetfile('D:\SpikeSortingPipeline\Sorted\*.mat','Select a rez file');
    load(fullfile(fpath,fname),'rez');
else
    display = 0;
    if nargin < 2
        load(fullfile(fpath,'rez.mat'),'rez_merged');
    end
    cd(fpath);
end

% rez = rez_merged;
% time window to sample and display
param.sample_win = -35:35;
param.view_win = -25:25;

% extract spikes
out = getRawWaveforms1(rez, param.sample_win);
clusters = unique(out.spikeClusters);
clusters=clusters(2:end); % not using cluster 0

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
mkdir('images');
if display % user selects cluster to graph
    figClust = figure('Name','View by Cluster','NumberTitle','off');
    set(gcf,'pos',[400 200 1000 600]);
    uicontrol('Style','listbox','Position',[10,10,50,200],'String',num2str(clusters-1),...
        'Callback',@(src,event) createClusterGrid(figClust,out,param,clusters(event.Source.Value)));
else % graph and save all clusters
    tic;
    for i = 1:size(clusters,1)
        clustNum = clusters(i);
        %fig = figure();
        figure
        set(gcf,'pos',[400 200 1000 600]);
        createClusterGrid(figure,out,param,clustNum);
       % saveas(fig,['images\cluster_',num2str(clustNum-1),'.png']);
        print(['images\cluster_',num2str(clustNum-1)],'-dpng');
        close(figure);
    end
    fprintf('graphSpikes took %2.2f minutes to run \n', floor(toc/0.6)/100);
end

end
