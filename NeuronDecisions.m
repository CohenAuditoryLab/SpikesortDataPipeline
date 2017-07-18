function NeuronDecisions(varargin)
%First argument - full file path to .mat file containing results of metrics
%Second argument - full path to save directory 
%OPTIONAL Third argument - full path to metrics folder
%% Handle variable argument numbers for automated vs. manual options

if nargin < 2
    wave_or_kilo = questdlg('Is your data from WaveClus or KiloSort?',...
        'Wave or Kilo?','wave','kilo','wave');
    disp('Select data file')
    [fname,fpath] = uigetfile();
    fpath = fullfile(fpath,fname);
    disp(fpath);
    disp('Select save path')
    new_directory = uigetdir();
    disp(new_directory);
    metrics = questdlg('Would you like to select a different folder for metrics?',...
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
    new_directory = varargin{2};
    if nargin > 2
        wave_or_kilo = varargin{3};
    else
end
%% Load data and initialize figure/table/table callback

output = load(fpath);
g = output.standard_output;
f = figure('Color', 'White');
set(f, 'name','Neuron Decisions');
pos = f.Position;
ax = axes('Visible', 'off');
t = uitable(f, 'CellSelectionCallback', @cellSelect);

%% UI for selecting clusters and button for submitting

clusters = unique(g(:,1));
d = cell(length(clusters), 2);

for j = 1:length(clusters)
    d(j, 1:2) = {num2str(clusters(j)), true};
end

figure(f);
button = uicontrol('Visible', 'on', 'style','pushbutton','units', ...
    'pixels','string','Submit');
set(button, 'Callback', {@callback});
button.Position(4) = 30;

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
set(f, 'WindowStyle','docked');
set(f, 'units', 'normalized', 'position',[0 0 1 1])

button.Position(2) = button.Position(4);
button.Position(3) = 119;

%% Images to be displayed on home screen

try
    isi = axes('Units', 'Pixels','Position', ...
        [(t.Position(3)+100)  pos(4) 450 350], 'Visible', 'Off');
    imisi = imread([metrics filesep 'isi__high_violators.png']);
    figure(f); axes(isi); image(imisi); axis tight;
catch   
end 

autocor = axes('Units', 'Pixels', 'Position', [(t.Position(3) + 100) 0 450 350]);
imauto = imread([metrics filesep 'pairwisecorr_0lag_sig.png']);
figure(f); axes(autocor); image(imauto); axis tight; axis off;

%% Triangular matrix table and figure initialization and formatting

ftri = figure();
set(ftri, 'name','Correlations Matrix');
triang = TriangTable(metrics);

tritab = uitable(ftri, 'Data', triang);
set(ftri, 'WindowStyle', 'docked');
tritab.RowName = clusters;
tritab.ColumnName = clusters;

set(tritab, 'units', 'normalized', 'position', [0 0 1 1], 'CellSelectionCallback', @triSelect);
%% Listbox intialization and formatting

otherfiles = {'autocorr__autocorr_valley_r.png', 'autocorr_diff_halves.png', ...
    'drift__frate_slope.png', 'drift__frate.png', 'isi__refractory_violations_per_spike.png', ...
    'pairwisecorr_0lag.png'};
figure(f);
lb = uicontrol('Style', 'listbox','Position',[(isi.Position(3) + isi.Position(1) + 10)...
    1.45*pos(4) 200 100],'string',otherfiles,'Max', 2, 'Callback',@listboxImage);

%% Set up axes for additional main screen graphs

extra1 = axes('Units', 'Pixels', 'Visible', 'Off', 'Position', ...
    [(lb.Position(1) + lb.Position(3) + 10) isi.Position(2) 450 350]);
extra2 = axes('Units', 'Pixels', 'Visible', 'Off', 'Position', ...
    [(lb.Position(1) + lb.Position(3) + 10) 0 450 350]);

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
        
        save(fullfile(new_directory,'final_clusters'), 'g')
        close all;
    end

    function cellSelect(hObj,event)
        selected = t.Data(event.Indices(1), :);
        c = selected{1};
        dot = strfind(c, '.');
        
        %         if strcmp(wave_or_kilo, 'wave')
        %             imfile = ['cluster_' c(1:dot-1) '_' c(dot+1:end) '.png'];
        %             imsorted = imread([new_directory filesep 'WaveClus' filesep imfile]);
        %         elseif strcmp(wave_or_kilo, 'kilo')
        %             imfile = ['cluster_' c '.png'];
        %             imsorted = imread([new_directory filesep 'KiloSort' filesep imfile]);
        %         end
        %         f1 = figure();
        %         set(f1, 'WindowStyle','docked', 'name', 'Waveform');
        %         figure(f1); image(imsorted); axis off; axis tight;
        
        imisidis = imread([metrics filesep 'isi_distributions' filesep 'isi__distribution_' c '.png']);
        f2 = figure();
        set(f2, 'WindowStyle','docked','name','ISI Distribution');
        figure(f2); image(imisidis); axis off; axis tight;
        
        imaut = imread([metrics filesep 'autocorrelations' filesep 'autocorr_cluster' c '.png']);
        %imread([metrics filesep 'autocorrelations' filesep 'autocorr_cluster' c '.png']);
        f3 = figure();
        set(f3, 'WindowStyle','docked','name','Autocorrelelogram');
        figure(f3); image(imaut); axis off; axis tight;
    end

    function triSelect(hObj,event)
        try
            n1 = clusters(event.Indices(2));
            n2 = clusters(event.Indices(1));
            
            imcor = imread([metrics filesep 'cross_correlograms' filesep ...
                'xcorr_' num2str(n1) '_' num2str(n2) '.png']);
            fcor = figure('WindowStyle', 'docked', 'name', 'Cross Correlelogram');
            figure(fcor); image(imcor); axis off; axis tight;
        catch
            msg = msgbox('This cross correlelogram was not computed.', 'Error');
        end
    end

    function listboxImage(hObj, event)
        e = event.Source.String(event.Source.Value);

        cla(extra1); 
        imextra1 = imread([metrics filesep e{1}]);
        figure(f); axes(extra1); image(imextra1); axis tight; axis off;
        
        if length(e) > 1
            cla(extra2);
            imextra2 = imread([metrics filesep e{2}]);
            figure(f); axes(extra2); image(imextra2); axis tight; axis off;
        end
    end

end
