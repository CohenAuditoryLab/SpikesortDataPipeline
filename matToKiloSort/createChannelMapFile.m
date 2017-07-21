function createChannelMapFile(fpath,Nchannels)
%createChannelMapFile  Create a chanMap file for a KiloSort simulation.

if nargin<2
    Nchannels = 64; 
end

connected   = true(Nchannels, 1);
chanMap     = 1:Nchannels;
chanMap0ind = chanMap - 1;
xcoords     = []; % all channels in same x-coord
ycoords     = []; % channels spaced evenly along y-axis
kcoords     = ones(1,Nchannels); % grouping of channels (i.e. tetrode groups)

%%%%
% Form for running MultiBrush arrays, channel position is unkown
% xcoords = zeros(nchannels,1);
% ycoords = 50 * [1:nchannels];
% kcoords = ones(nchannels,1);
%%%%

save(fullfile(fpath, 'chanMap.mat'), ...
    'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind')
end
