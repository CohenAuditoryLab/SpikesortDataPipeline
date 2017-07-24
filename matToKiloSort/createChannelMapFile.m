function createChannelMapFile(fpath,num_channels)
%createChannelMapFile  Create a chanMap file for a KiloSort simulation.

connected   = true(num_channels, 1);
chanMap     = 1:num_channels;
chanMap0ind = chanMap - 1;
xcoords     = []; % all channels in same x-coord
ycoords     = []; % all channels in same y-coord
kcoords     = ones(1,num_channels); % grouping of channels (i.e. tetrode groups)

%%%%
% Form for running MultiBrush arrays, channel position is unkown
% xcoords = zeros(num_channels,1);
% ycoords = 50 * [1:num_channels];
% kcoords = ones(num_channels,1);
%%%%

save(fullfile(fpath, 'chanMap.mat'), ...
    'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind')
end
