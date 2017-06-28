function NeuronDecisions(varargin)

if nargin < 2 
    disp('Select data path')
    fpath = uigetdir();
    disp('Select save path')
    new_directory = uigetdir();
else 
    fpath = varargin{1};
    new_directory = varargin{2};
end
    
output = load(fpath);
g = output.standard_output;
f = figure();
pos = f.Position;
ax = axes('Visible', 'off');
t = uitable(f);

clusters = unique(g(:,1));
d = cell(length(clusters), 2);

for j = 1:length(clusters)
    d(j, 1:2) = {num2str(clusters(j)), true};
end

t.Data = d;

button = uicontrol('Visible', 'on', 'style','pushbutton','units', ...
    'pixels','string','Submit');
set(button, 'Callback', {@callback});
button.Position(4) = 30;
button.Position(2) = 0;
button.Position(3) = 119;
uicontrol('Style','text', 'String','Neuron Decisions', 'Position', [15 407 100 15]);
t.ColumnName = {'Cluster','Included'};
t.ColumnEditable = [false, true];
t.ColumnWidth = {50, 50};
t.RowName = [];
t.Position(4) = pos(4) - 20 - button.Position(4);
t.Position(3) = 119;
t.Position(2) = t.Position(2) + 9;
f.Position(3) = 157;

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
        msgbox(['Saved final cluster decisions to: ' fullfile(new_directory,'final_clusters') '.mat']);
    end

end
