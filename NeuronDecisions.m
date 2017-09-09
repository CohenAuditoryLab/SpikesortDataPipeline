function NeuronDecisions(varargin)
%First argument - full file path to .mat file containing results of metrics
%OPTIONAL Second argument - 'wave' or 'kilo' (lack of this will prompt user
%in dialog box)
%OPTIONAL Third argument - path to metrics folder
%% Handle variable argument numbers for automated vs. manual options

if nargin < 1
    wave_or_kilo = questdlg('Is your data from WaveClus or KiloSort?',...
        'Wave or Kilo?','wave','kilo','wave');
    disp('Select data file');
    [fname,fpath] = uigetfile();
    fpath = fullfile(fpath,fname);
    disp(fpath);
    slash = strfind(fpath, filesep);
    new_directory = fpath(1:slash(end-1));
    metrics = questdlg('Would you like to select a folder for metrics other than the default?',...
        'Metrics Folder','Yes','No','No');
    if strcmp(metrics, 'Yes')
        disp('Select the metrics folder');
        metrics = uigetdir();
    else
        %update this to be the Metrics directory on the kilosort computer
        metrics = [new_directory filesep 'Metrics'];
    end
    disp(metrics);
else
    fpath = varargin{1};
    slash = findstr(fpath, filesep);
    new_directory = fpath(1:slash(end-1));
    if nargin > 1
        wave_or_kilo = varargin{2};
    else
        wave_or_kilo = questdlg('Is your data from WaveClus or KiloSort?',...
            'Wave or Kilo?','wave','kilo','wave');
    end
    if nargin > 2
        metrics = varargin{3};
    else
        metrics = questdlg('Would you like to select a folder for metrics other than the default?',...
            'Metrics Folder','Yes','No','No');
        if strcmp(metrics, 'Yes')
            disp('Select the metrics folder');
            metrics = uigetdir();
        else
            %update this to be the Metrics directory on the kilosort computer
            metrics = [new_directory filesep 'Metrics'];
        end
    end
end

%% Load data and initialize figure/table/table callback/main tabs

output = load(fpath);
g = output.standard_output;
f = figure('Name', 'Neuron Decisions');
pos = f.Position;

tabgp = uitabgroup(f);
tabmain = uitab(tabgp, 'Title', 'Select Neurons', 'BackgroundColor', 'White');
tabgp2 = uitabgroup(tabmain, 'Units', 'Pixels', 'Position', [400 20 900 700]);
tablb = uitab(tabgp2, 'Title', 'Metrics');
wavtab = uitab(tabgp2, 'Title', 'Waveform');
isitab = uitab(tabgp2, 'Title', 'ISI');
auttab = uitab(tabgp2, 'Title', 'Autocorrelations');
wavtab.Parent = [];
tablb.Parent = [];
isitab.Parent = [];
auttab.Parent = [];

t = uitable(tabmain, 'CellSelectionCallback', @cellSelect);

%% UI for selecting clusters and button for submitting

clusters = unique(g(:,1));
d = cell(length(clusters), 2);

for j = 1:length(clusters)
    d(j, 1:2) = {num2str(clusters(j)), true};
end

button = uicontrol('Parent', tabmain, 'Visible', 'on', ...
    'style','pushbutton','units', 'pixels','string','Submit');
set(button, 'Callback', {@callback});
button.Position(4) = 30;

% closebutton = uicontrol('Parent', tabmain, 'Visible', 'on', 'style', 'pushbutton', ...
%     'units', 'pixels', 'Position', [800 725 130 30], 'string', 'Close Current Tab');
% set(closebutton, 'Callback', {@closeTabCallback});

%% Data table, initial figure, button formatting

t.Data = d;
t.ColumnName = {'Cluster','Included'};
t.ColumnEditable = [false, true];
t.ColumnWidth = {50, 50};
t.RowName = [];

t.Position(4) = 2 * (pos(4) - 50 - button.Position(4));
t.Position(3) = 119;
t.Position(2) = button.Position(4) + 50;

f.Position(3) = 157 * 5;
f.Position(4) = 2 * pos(4);
set(f, 'units', 'normalized', 'position',[0 0 1 1])

button.Position(1) = button.Position(1) + 7;
button.Position(2) = button.Position(4);
button.Position(3) = 119;

%% Listbox intialization and formatting

otherfiles = {'autocorr__autocorr_valley_r.png', 'autocorr_diff_halves.png', ...
    'drift__frate_slope.png', 'drift__frate.png', 'isi__refractory_violations_per_spike.png', ...
    'pairwisecorr_0lag.png', 'pairwisecorr_0lag_sig.png', 'isi__high_violators.png'};
lb = uicontrol('Style', 'listbox', 'Parent', tabmain, 'Position',...
    [(t.Position(3) + 50) t.Position(1) 200 150],'string',...
    otherfiles,'Max', 2, 'Callback',@listboxImage);

%% Triangular matrix table and tab initialization and formatting

tabtri = uitab(tabgp, 'Title', 'Neuron Correlations', 'BackgroundColor', 'white');
subtabs = uitabgroup(tabtri, 'Units', 'Normalized', 'Position', [0 0 1 1]);
tabmat = uitab(subtabs, 'Title', 'Correlation Matrix', 'BackgroundColor', 'white');
tabfig = uitab(subtabs, 'Title', 'Cross Correlelogram', 'BackgroundColor', 'white');
tabfig.Parent = [];
%triang = TriangTable(metrics);

cr = load([metrics filesep 'pairwise_corr_result.mat']);
tri = tril(cr.corr_result.pearson_Rs);
triang = cell(size(tri));

for i = 1:size(tri, 1)
    row = tri(i, :);
    ind = find(row == 1);
    newrow = row(1:ind(end) - 1);
    triang(i, 1:length(newrow)) = mat2cell(newrow, [1], ones(1,size(newrow,2)));
end 

%highlight text red over a particular value
rows = size(triang, 1);
for j = 1:rows
    r = cell2mat(triang(j, :));
    ind = find(abs(r) >= 0.005);
    for k = ind
        triang{j,k} = strcat(...
    '<html><tr><td align=right  width=999999><span style="color: #FF0000;">', ...
    num2str(triang{j,k}), '</span></tr></td></html>');
    end
end

tritab = uitable(tabmat, 'Data', triang);
tritab.RowName = clusters;
tritab.ColumnName = clusters;

%set(tritab, 'CellSelectionCallback', @triSelect);
set(tritab, 'units', 'normalized', 'position', [0 0 1 1], ...
    'CellSelectionCallback', @triSelect);

%% Callback functions

    function callback(hObj,event)
        d = t.Data;
        data(:,1) = str2double(d(:,1));
        data(:,2) = cell2mat(d(:,2));
        
        unchecked = data(:,2) == 0;
        data = data(unchecked,1);
        
        for i = 1:length(data)
            g = g(g(:,1) ~= data(i),:);
        end
        [a,b,~] = fileparts(strip(new_directory,'right',filesep));
        [~,c,~] = fileparts(a);
        
        save(fullfile(new_directory,[c '_' b  '_finalclusters']), 'g')
        close all;
    end

    function cellSelect(hObj,event)
        
        checkbox = event.Indices(2);
        
        %only open figures if you click in the first column
        if checkbox == 1
            selected = t.Data(event.Indices(1), :);
            c = selected{1};
            dot = strfind(c, '.');
            
            try
                if strcmp(wave_or_kilo, 'wave')
                    imfile = ['cluster_' c(1:dot-1) '_' c(dot+1:end) '.png'];
                    %THIS PATH MIGHT NEED TO BE MODIFIED.
                    imsorted = imread([new_directory filesep 'WaveClus' filesep imfile]);
                elseif strcmp(wave_or_kilo, 'kilo')
                    imfile = ['cluster_' c '.png'];
                    %THIS PATH MIGHT NEED TO BE MODIFIED.
                    imsorted = imread([new_directory filesep 'KiloSort' filesep imfile]);
                end
                wavax = axes('Visible', 'Off', 'Parent', wavtab, 'Units', 'Normalized', 'Position', [0 0 1 1]);
                set(wavtab, 'Title', ['Waveform, Neuron ' c]);
                wavtab.Parent = tabgp2;
                image(imsorted, 'Parent', wavax); axis off; axis tight;
                set(wavax, 'XTick', [], 'YTick', []);
                set(wavax, 'Visible', 'Off');
            catch
            end
            
            set(isitab, 'Title', ['ISI Distribution, Neuron ' c]);
            imisidis = imread([metrics filesep 'isi_distributions' filesep 'isi__distribution_' c '.png']);
            isiax = axes('Visible', 'Off', 'Parent', isitab, 'Units',...
                'Normalized', 'Position', [0 0 1 1]);
            isitab.Parent = tabgp2;
            image(imisidis, 'Parent', isiax); axis off; axis tight;
            set(isiax, 'XTick', [], 'YTick', []);
            set(isiax, 'Visible', 'Off');
            
            set(auttab, 'Title', ['Autocorrelelogram, Neuron ' c]);
            imaut = imread([metrics filesep 'autocorrelations' filesep 'autocorr_cluster' c '.png']);
            autax = axes('Visible', 'Off', 'Parent', auttab, 'Units', ...
                'Normalized', 'Position', [0 0 1 1]);
            auttab.Parent = tabgp2;
            image(imaut, 'Parent', autax); axis tight; axis off;
            set(autax, 'XTick', [], 'YTick', []);
            set(autax, 'Visible', 'Off');
            
            tabgp2.SelectedTab = isitab;
        end
    end

    function triSelect(hObj,event)
        try
            n1 = clusters(event.Indices(2));
            n2 = clusters(event.Indices(1));
            
            imcor = imread([metrics filesep 'cross_correlograms' filesep ...
                'xcorr_' num2str(n1) '_' num2str(n2) '.png']);
            corax = axes('Parent', tabfig, 'Units', 'Normalized', 'Visible',...
                'Off', 'Position', [.125 0 .75 1]);
            tabfig.Parent = subtabs;
            image(imcor, 'Parent', corax); axis off; axis tight;
            set(corax, 'XTick', [], 'YTick', []);
            set(corax, 'Visible', 'Off');
            
            subtabs.SelectedTab = tabfig;
            set(tabfig, 'Title', ['Neuron ' num2str(n1) ' vs. Neuron ' num2str(n2)]);
        catch
            err = msgbox('This cross correlelogram was not computed.', 'Error');
        end
    end

    function listboxImage(hObj, event)
        e = event.Source.String(event.Source.Value);
        
        try
            tablb.Parent = tabgp2;
            extra1 = axes('Parent', tablb, 'Units', 'Normalized', ...
                'Visible', 'Off', 'Position', [0 0 1 1]);
            imextra1 = imread([metrics filesep e{1}]);
            axes(extra1); image(imextra1); axis tight; axis off;
            tabgp2.SelectedTab = tablb;
            set(extra1, 'XTick', [], 'YTick', []);
            set(extra1, 'Visible', 'Off');
        catch
            msg = msgbox('This figure is not available in your metrics directory.', 'Error');
        end
    end

    function closeTabCallback(hObj, event)
        %get current tab and delete it
        selected = tabgp2.SelectedTab;
        delete(selected);
    end
end