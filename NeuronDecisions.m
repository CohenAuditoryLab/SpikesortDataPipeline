function NeuronDecisions(varargin)
%% Handle variable argument numbers for automated vs. manual options
if nargin < 2 
    wave_or_kilo = questdlg('Is your data from WaveClus or KiloSort?',...
        'Wave or Kilo?','wave','kilo','wave');
    disp('Select data path')
    [fname,fpath] = uigetfile();
    fpath = fullfile(fpath,fname);
    display(fpath);
    disp('Select save path')
    %save path should be base folder containing kilosort and waveclus
    %subfolders
    new_directory = uigetdir();
else 
    fpath = varargin{1};
    new_directory = varargin{2};
    wave_or_kilo = varargin{3};
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

isi = axes('Units', 'Pixels','Position', [(t.Position(3)+100)  pos(4) 450 350]);
imisi = imread([new_directory filesep 'kilo_output_metrics' filesep 'isi__high_violators.png']);
figure(f); image(imisi); axis tight; axis off;

autocor = axes('Units', 'Pixels', 'Position', [(t.Position(3) + 100) 0 450 350]);
imauto = imread([new_directory filesep 'kilo_output_metrics' filesep 'pairwisecorr_0lag_sig.png']);
figure(f); image(imauto); axis tight; axis off;

%% Triangular matrix table and figure initialization and formatting 

ftri = figure();
set(ftri, 'name','Correlations Matrix');
triang = TriangTable(clusters);

tritab = uitable(ftri, 'Data', triang(2:end, :));
set(ftri, 'WindowStyle', 'docked');
tritab.RowName = triang(1,:);
tritab.ColumnName = [];

set(tritab, 'units', 'normalized', 'position', [0 0 1 1], 'CellSelectionCallback', @triSelect);

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
        
        if strcmp(wave_or_kilo, 'wave')
            imfile = ['cluster_' c(1:dot-1) '_' c(dot+1:end) '.png'];
            imsorted = imread([new_directory filesep 'WaveClus' filesep imfile]);
        elseif strcmp(wave_or_kilo, 'kilo')
            imfile = ['cluster_' c '.png'];
            imsorted = imread([new_directory filesep 'KiloSort' filesep imfile]);
        end
        f1 = figure();
        set(f1, 'WindowStyle','docked', 'name', 'Waveform');
        figure(f1); image(imsorted); axis off; axis tight;
        
        imisidis = imread([new_directory filesep 'kilo_output_metrics' filesep 'isi_distribution_' c]);
        f2 = figure();
        set(f2, 'WindowStyle','docked','name','ISI Distribution');
        figure(f2); image(imisidis); axis off; axis tight;
        
        imaut = imread([new_directory filesep 'kilo_output_metrics' filesep 'autocorrelations' filesep 'autocorr_cluster0' '.png']);
        %imread([new_directory filesep 'kilo_output_metrics' filesep 'autocorrelations' filesep 'autocorr_cluster' c '.png']);
        f3 = figure();
        set(f3, 'WindowStyle','docked','name','Autocorrelogram');
        figure(f3); image(imaut); axis off; axis tight;
    end 

    function triSelect(hObj,event)
        headings = cell2mat(triang(1, :));
        
        n1 = headings(event.Indices(1));
        
        n = find(headings == n1);
        m = find(cell2mat(tritab.Data(1, :)) == cell2mat(tritab.Data(event.Indices(2))));
        n2 = tritab.Data(n,m);
        n2 = n2{1};
        
        imcor = imread([new_directory filesep 'kilo_output_metrics' filesep ...
            'cross_correlograms' filesep 'xcorr_' num2str(n1) '_' num2str(n2) '.png']);
        fcor = figure('WindowStyle', 'docked', 'name', 'Cross Correlogram');
        figure(fcor); image(imcor); axis off; axis tight;
    end

end
