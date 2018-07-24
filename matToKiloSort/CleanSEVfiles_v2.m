function [] = CleanSEVfiles_v2(DataTank,TDTtankPath,SavePath,channels,channel_group,channel_dead,ndim_res)
%% Data parameters

% TDTtankPath = '/data/NIF/rawdata/russbe/Matcha/Orig/';
% SavePath = '/data/NIMH_NIF/scratch/koyanok/';
if nargin < 2
    disp('Aborted: no Tank sent to function, check inputs')
    return
end

if ~exist('SavePath','var') || isempty(SavePath)
    SavePath = '/data/NIF/rawdata/russbe/Matcha/Unsorted/';
end

if ~exist('channels','var') || isempty(channels)
    channels = [65:128];
elseif ischar(channels)
    eval(['channels = [' channels '];']);
end

if ~exist('channel_group','var') || isempty(channel_group)
    channel_group = 64;
elseif ischar(channel_group)
    channel_group = str2double(channel_group);
end

if ~exist('channel_dead','var') || isempty(channel_dead)
    channel_dead = [];
elseif ischar(channel_dead)
    eval(['channel_dead = [' channel_dead '];']);
end
channel_dead_indx = ismember(channels,channel_dead);

if ~exist('ndim_res','var') || isempty(ndim_res)
    ndim_res = 2;   % number of principal components to be removed
elseif ischar(ndim_res)
    eval(['ndim_res = [' ndim_res '];']);
end

filter_hp = 100;    % high-pass frequency
filter_lp = 5000;   % low-pass frequency
filter_n  = 4;      % filter order

% int16_scale_factor = 3276700;

%% Checking availability of statistics toolbox
% disp('    checking statistics toolbox license...')
% avail_license = 0;  % flag for statistics toolbox license
% while ~avail_license
%     msg = evalc('!licenses -stat');
%     avail_license = str2double(msg(2));
%     if avail_license>0
%         disp('    statistics toolbox is available')
%     else
%         pause(5);
%     end
% end


%% Run the Preprocessing function for all paths 

greattic = tic;
                                                     % loop for tank
NeuroTankPath = [TDTtankPath DataTank filesep];
disp(['Beginning tank ' DataTank]);
folderlist = dir(NeuroTankPath);
isd = [folderlist(:).isdir];
blocklist = {folderlist(isd).name}';
blocklist(ismember(blocklist,{'.','..'})) = [];
clear folderlist isd;
%     blocklist = {'Resting2'};
for jj = 1:1%length(blocklist)                                                % loop for block
%         
    BlockPath   = [NeuroTankPath blocklist{jj} filesep];

    if ~(exist([SavePath DataTank],'dir'))
        mkdir([SavePath DataTank]);
    end
    if ~(exist([SavePath DataTank filesep blocklist{jj}],'dir'))
        mkdir([SavePath DataTank filesep blocklist{jj}]);
    end

    SevSavePath = [SavePath DataTank filesep blocklist{jj} filesep];
    disp(['  Beginning block ' blocklist{jj}]);
    disp('    reading sev file...')
    for kk = 1:length(channels)                                           % loop for channel
        filelist = dir([BlockPath '*ch' num2str(channels(kk)) '.sev']);
        if ~isempty(filelist)
            disp(['      Ch ' num2str(channels(kk))]);
            SevFile = [BlockPath filelist(1).name];
            
            header = CheckforHeader(SevFile); % determing if the data has a header
            
            if header == 1 % if header use TDT SEV2mat function
                [rawdat, fs] = SEV2mat_singleCh(SevFile);                        % load data
            else % if no header just straight load the full data.
                fid = fopen(SevFile);
                rawdat = fread(fid,'int16');
                rawdat = int16(rawdat)';
                fs = 24414.06250000000;
                fclose(fid);
            end
                
            if ~exist('alldat','var')
                alldat = nan(length(channels),length(rawdat));
                fslist = nan(length(channels),1);
            end
            if isa(rawdat,'int16')
                rawdat = single(rawdat);
                dattype = 'int16';
%                     rawdat = rawdat./int16_scale_factor;
            elseif isa(rawdat,'single')
                dattype = 'single';
            else
                dattype = 'other';
            end

            alldat(kk,:) = rawdat;
            fslist(kk,:) = fs;
        else
            disp(['    Ch ' num2str(channels(kk)) ' does not exist']);
        end
        clear rawdat fs filelist SevFile;
    end
    disp('    all loaded');
    process_time = toc(greattic);
    process_hour = floor(process_time/3600);
    process_min  = floor(process_time/60)-process_hour*60;
    process_sec  = round(process_time - process_hour*3600 - process_min*60);
    disp(['    ' num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
    disp(' ');

    %% Mean signal subtraction
    disp('    subtracting mean...');
    for kk = 1:ceil(length(channels)/channel_group)
        start_dat = channel_group*(kk-1)+1;
        end_dat   = channel_group*kk;
        if end_dat>length(channels)
            end_dat = length(channels);
        end
        disp(['      Ch ' num2str(channels(start_dat)) ' to ' num2str(channels(end_dat))]);
        channel_indx = start_dat:end_dat;
%             channel_indx(channel_dead_indx(start_dat:end_dat)) = [];
        mean_subtract = nanmean(alldat(channel_indx,:),1);
%         disp('nanmean');
        alldat(start_dat:end_dat,:) = alldat(start_dat:end_dat,:) - repmat(mean_subtract,[end_dat-start_dat+1,1]);
%         disp('repmat');
        clear start_dat end_dat mean_subtract;
    end
    disp('    subtracted');
    process_time = toc(greattic);
    process_hour = floor(process_time/3600);
    process_min  = floor(process_time/60)-process_hour*60;
    process_sec  = round(process_time - process_hour*3600 - process_min*60);
    disp(['    ' num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
    disp(' ');


    %% Remove principal components
    disp(['    subtracting first ' num2str(ndim_res) ' principal components...']);
    for kk = 1:ceil(length(channels)/channel_group)
        start_dat = channel_group*(kk-1)+1;
        end_dat   = channel_group*kk;
        if end_dat>length(channels)
            end_dat = length(channels);
        end
        disp(['      Ch ' num2str(channels(start_dat)) ' to ' num2str(channels(end_dat))]);
        channel_indx = start_dat:end_dat;
        channel_indx(channel_dead_indx(start_dat:end_dat)) = [];
        alldat(channel_indx,:) = (pcares(alldat(channel_indx,:)',ndim_res))';
        clear start_dat end_dat;
    end
    disp('    subtracted');
    process_time = toc(greattic);
    process_hour = floor(process_time/3600);
    process_min  = floor(process_time/60)-process_hour*60;
    process_sec  = round(process_time - process_hour*3600 - process_min*60);
    disp(['    ' num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
    disp(' ');

    %% Filtering
%     disp('    filtering...')
%     fs = fslist(1);
%     WnHP = filter_hp / (fs/2) ;
%     WnLP = filter_lp / (fs/2) ;
%     [bHP, aHP] = butter(filter_n, WnHP,'high');
%     [bLP, aLP] = butter(filter_n, WnLP,'low');        
%     tmp_filtered = filtfilt(bHP,aHP,alldat');
%     alldat = filtfilt(bLP,aLP,tmp_filtered)';
%     clear tmp_filtered;
%     disp('    filtered.')
%     process_time = toc(greattic);
%     process_hour = floor(process_time/3600);
%     process_min  = floor(process_time/60)-process_hour*60;
%     process_sec  = round(process_time - process_hour*3600 - process_min*60);
%     disp(['    ' num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
%     disp(' ');

    %% Save sev data
    disp('    saving sev data...');
    for kk = 1:length(channels)
        disp(['      Ch ' num2str(channels(kk))]);
        SevSaveFile = [SevSavePath 'ch' num2str(channels(kk)) '.sev'];
        fid=fopen(SevSaveFile,'w');
        switch dattype
            case 'int16'
                fwrite(fid,alldat(kk,:),'int16');
            case 'single'
                fwrite(fid,alldat(kk,:),'single');
            otherwise
                fwrite(fid,alldat(kk,:));
        end
        fclose(fid);
        clear SevSaveFile;
    end
    disp('    saved.')
    process_time = toc(greattic);
    process_hour = floor(process_time/3600);
    process_min  = floor(process_time/60)-process_hour*60;
    process_sec  = round(process_time - process_hour*3600 - process_min*60);
    disp(['    ' num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
    disp(' ');

    clear alldat;
end
clear blocklist;
disp(['Finished ' DataTank ' convert']);
process_time = toc(greattic);
process_hour = floor(process_time/3600);
process_min  = floor(process_time/60)-process_hour*60;
process_sec  = round(process_time - process_hour*3600 - process_min*60);
disp([num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
disp(' ');


disp('Finished convertitng');
process_time = toc(greattic);
process_hour = floor(process_time/3600);
process_min  = floor(process_time/60)-process_hour*60;
process_sec  = round(process_time - process_hour*3600 - process_min*60);
disp(['    ' num2str(process_hour) 'h ' num2str(num2str(process_min)) 'min ' num2str(process_sec) 'sec']);
disp(' ');
clear tanklist;
% exit

%%%% 
function [header] = CheckforHeader(sevFile)
%%
fid = fopen(sevFile);
TDTHeader.fileSizeBytes = fread(fid,1,'uint64');        % file size recorded in the "header"
TDTHeader.fileType      = char(fread(fid,3,'char'))';   % file type recorded in the "header"
TDTHeader.fileVersion   = fread(fid,1,'char');          % file ver. recorded in the "header"
D_sevFile = dir(sevFile);                           % actual file size
if TDTHeader.fileSizeBytes==D_sevFile.bytes     % if the file size information is correct
    header = 1; % header exists
else
    header = 0;                 % if the file size information is incorrect, no header (probably header was removed already)
end
fclose(fid);

%%
%%%%
function [rawdata, fs] = SEV2mat_singleCh(SEV_FILE)
%%
%SEV2MAT  TDT SEV file format extraction.
%   data = SEV2mat_singleCh(SEV_FILE), where SEV_FILE is a string, 
%   retrieves a sev data from specified file. SEV files
%   are generated by an RS4 Data Streamer, or by setting the Unique
%   Channel Files option in Stream_Store_MC or Stream_Store_MC2 macro
%   to Yes.
%
%   data    contains all continuous data (sampling rate and raw data)
%
%   modified from SEV2mat from TDT, by Kenji Koyano
%   last modified: 150803


data = [];

ALLOWED_FORMATS = {'single','int32','int16','int8','double','int64'};

% open file
fid = fopen(SEV_FILE, 'rb');

if fid < 0
    warning([SEV_FILE ' not opened'])
    return
end
    
% create and fill streamHeader struct
streamHeader = [];

streamHeader.fileSizeBytes   = fread(fid,1,'uint64');
streamHeader.fileType        = char(fread(fid,3,'char')');
streamHeader.fileVersion     = fread(fid,1,'char');

if streamHeader.fileVersion < 3
    
    % event name of stream
    if streamHeader.fileVersion == 2
        streamHeader.eventName  = char(fread(fid,4,'char')');
    else
        streamHeader.eventName  = fliplr(char(fread(fid,4,'char')'));
    end
    
    % current channel of stream
    streamHeader.channelNum        = fread(fid, 1, 'uint16');
    % total number of channels in the stream
    streamHeader.totalNumChannels  = fread(fid, 1, 'uint16');
    % number of bytes per sample
    streamHeader.sampleWidthBytes  = fread(fid, 1, 'uint16');
    reserved                 = fread(fid, 1, 'uint16');
    
    % data format of stream in lower four bits
    streamHeader.dForm      = ALLOWED_FORMATS{bitand(fread(fid, 1, 'uint8'),7)+1};
    
    % used to compute actual sampling rate
    streamHeader.decimate   = fread(fid, 1, 'uint8');
    streamHeader.rate       = fread(fid, 1, 'uint16');
    
    % reserved tags
    reserved = fread(fid, 1, 'uint64');
    reserved = fread(fid, 2, 'uint16');
    
else
    error(['unknown version ' num2str(streamHeader.fileVersion)]);
end
    
%varname = matlab.lang.makeValidName(streamHeader.eventName);
varname = streamHeader.eventName;
for ii = 1:numel(varname)
    if ii == 1
        if isnumeric(varname(ii))
            varname(ii) = 'x';
        end
    end
    if ~isletter(varname(ii)) && ~isnumeric(varname(ii))
        varname(ii) = '_';
    end
end
% if ~isvarname(streamHeader.eventName)
%     warning('%s is not a valid Matlab variable name, changing to %s', streamHeader.eventName, varname);
% end

if streamHeader.fileVersion > 0
    % determine data sampling rate
    streamHeader.fs = 2^(streamHeader.rate)*25000000/2^12/streamHeader.decimate;
    % handle multiple data streams in one folder
    exists = isfield(data, varname);
else
    streamHeader.dForm = 'single';
    streamHeader.fs = 0;
    s = regexp(file_list(i).name, '_', 'split');
    streamHeader.eventName = s{end-1};
    %varname = matlab.lang.makeValidName(streamHeader.eventName);
    varname = streamHeader.eventName;
    for ii = 1:numel(varname)
        if ii == 1
            if isnumeric(varname(ii))
                varname(ii) = 'x';
            end
        end
        if ~isletter(varname(ii)) && ~isnumeric(varname(ii))
            varname(ii) = '_';
        end
    end
    
%     if ~isvarname(streamHeader.eventName)
%         warning('%s is not a valid Matlab variable name, changing to %s', streamHeader.eventName, varname);
%     end
    streamHeader.channelNum = str2double(regexp(s{end},  '\d+', 'match'));
    warning('%s has empty header; assuming %s ch %d format %s and fs = %.2f\nupgrade to OpenEx v2.18 or above\n', ...
        file_list(i).name, streamHeader.eventName, ...
        streamHeader.channelNum, streamHeader.dForm, 24414.0625);
    
    exists = 1;
    data.(varname).fs = 24414.0625;
end


% read rest of file into data array as correct format
varname = streamHeader.eventName;
for ii = 1:numel(varname)
    if ii == 1
        if isnumeric(varname(ii))
            varname(ii) = 'x';
        end
    end
    if ~isletter(varname(ii)) && ~isnumeric(varname(ii))
        varname(ii) = '_';
    end
end

varname = matlab.lang.makeValidName(streamHeader.eventName);
% if ~isvarname(streamHeader.eventName)
%     warning('%s is not a valid Matlab variable name, changing to %s', streamHeader.eventName, varname);
% end
data.(varname).name = streamHeader.eventName;
if exists ~= 1
    %preallocate data array
    temp_data = fread(fid, inf, ['*' streamHeader.dForm])';
    total_samples = length(temp_data);
    func = str2func(streamHeader.dForm);
    data.(varname).data = func(zeros(1,total_samples));
    data.(varname).data(1,:) = temp_data;
    data.(varname).fs = streamHeader.fs;
else
    data.(varname).data(1,:) = fread(fid, inf, ['*' streamHeader.dForm])';
end

rawdata = data.(varname).data;
fs = data.(varname).fs;

% close file
fclose(fid);