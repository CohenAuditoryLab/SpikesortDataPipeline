function [rez, DATA, uproj,channels_files] = preprocessData_v3(ops,event_name)
%Event name
%AL var=xpz2 (33-128)
%ML var=xpz2(1:32)+xpz5(1-64)
progressbar('Whitening','Data');
tic;
uproj = [];
ops.nt0 	= getOr(ops, {'nt0'}, 61);
%event_name='AL';

if strcmp(ops.datatype , 'openEphys')
   ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
end

if ~isempty(ops.chanMap)
    if ischar(ops.chanMap)
        load(ops.chanMap);
        try
            chanMapConn = chanMap(connected>1e-6);
            xc = xcoords(connected>1e-6);
            yc = ycoords(connected>1e-6);
        catch
            chanMapConn = 1+chanNums(connected>1e-6);
            xc = zeros(numel(chanMapConn), 1);
            yc = [1:1:numel(chanMapConn)]';
        end
        ops.Nchan    = getOr(ops, 'Nchan', sum(connected>1e-6));
        ops.NchanTOT = getOr(ops, 'NchanTOT', numel(connected));
        if exist('fs', 'var')
            ops.fs       = getOr(ops, 'fs', fs);
        end
    else
        chanMap = ops.chanMap;
        chanMapConn = ops.chanMap;
        xc = zeros(numel(chanMapConn), 1);
        yc = [1:1:numel(chanMapConn)]';
        connected = true(numel(chanMap), 1);      
        
        ops.Nchan    = numel(connected);
        ops.NchanTOT = numel(connected);
    end
else
    chanMap  = 1:ops.Nchan;
    connected = true(numel(chanMap), 1);
    
    chanMapConn = 1:ops.Nchan;    
    xc = zeros(numel(chanMapConn), 1);
    yc = [1:1:numel(chanMapConn)]';
end
if exist('kcoords', 'var')
    kcoords = kcoords(connected);
else
    kcoords = ones(ops.Nchan, 1);
end
NchanTOT = ops.NchanTOT;
NT       = ops.NT ;

rez.ops         = ops;
rez.xc = xc;
rez.yc = yc;
if exist('xcoords')
   rez.xcoords = xcoords;
   rez.ycoords = ycoords;
else
   rez.xcoords = xc;
   rez.ycoords = yc;
end
rez.connected   = connected;
rez.ops.chanMap = chanMap;
rez.ops.kcoords = kcoords; 


file_list=dir([ops.fbinary '*.sev']);    
ops.sampsToRead = floor(file_list(end).bytes/2);%ops.sampsToRead = floor(file_list(1).bytes/NchanTOT/2); 
%number of samples per channel/2, since individual files no need to divide
%by NchanTOT

if ispc
    dmem         = memory;
    memfree      = dmem.MemAvailableAllArrays/8;
    memallocated = min(ops.ForceMaxRAMforDat, dmem.MemAvailableAllArrays) - memfree;
    memallocated = max(0, memallocated);
else
    memallocated = ops.ForceMaxRAMforDat;
end
nint16s      = memallocated/4;

NTbuff      = NT + 4*ops.ntbuff;
Nbatch      = ceil(file_list(end).bytes/4/(NT-ops.ntbuff));
%Nbatch      = ceil(file_list(1).bytes/2/NchanTOT /(NT-ops.ntbuff));
Nbatch_buff = floor(4/5 * nint16s/1 /(NT-ops.ntbuff)); % factor of 4/5 for storing PCs of spikes
%Nbatch_buff = floor(4/5 * nint16s/rez.ops.Nchan /(NT-ops.ntbuff)); % factor of 4/5 for storing PCs of spikes
Nbatch_buff = min(Nbatch_buff, Nbatch);

%%% load data into patches, filter, compute covariance
% if isfield(ops,'fslow')&&ops.fslow<ops.fs/2
%     [b1, a1] = butter(3, [ops.fshigh/ops.fs,ops.fslow/ops.fs]*2, 'bandpass');
% else
%     [b1, a1] = butter(3, ops.fshigh/ops.fs*2, 'high');
% end


%making comb filter to remove 60hz and harmonics
fs=ops.fs;
fo = 60;  q = 20; bw = (fo/(fs/2))/q;
[nb,na] = iircomb(floor(fs/fo),bw,'notch');
%bandpass filter
Fstop1 = 250;Fpass1 = 300;Fpass2 = 2900;Fstop2 = 3000;
Astop1 = 65;Apass  = 0.5;Astop2 = 65;
d = designfilt('bandpassfir', ...
  'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
  'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
  'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
  'StopbandAttenuation2',Astop2, ...
  'DesignMethod','equiripple','SampleRate',fs);


fprintf('Time %3.0fs. Loading raw data... \n', toc);
%Openning all channels appropiate variable

    if strcmp(event_name,'ML') %gathers all binaries of ML and AL
        index=contains({file_list.name},'xpz5');
        index_files=find(index==1);
        index_files=index_files(1:64);
        index2=contains({file_list.name},'xpz2');
        index_files2=find(index2==1);
        index_files2=index_files2(1:32);
        all_ML=[index_files index_files2];
            for bin_in=1:length(all_ML)
                fid{bin_in}=fopen(fullfile(file_list(all_ML(bin_in)).folder , file_list(all_ML(bin_in)).name));
                fread(fid{bin_in},10,'single'); %leave pointer at beginning of data
            end

    elseif strcmp(event_name,'AL')
        index=contains({file_list.name},'xpz2');
        index_files=find(index==1);
        all_AL=index_files(33:128);
        for bin_in=1:length(all_AL)
                fid{bin_in}=fopen(fullfile(file_list(all_AL(bin_in)).folder , file_list(all_AL(bin_in)).name));
                fread(fid{bin_in},10,'single');
        end
    end


ibatch = 0;
Nchan = rez.ops.Nchan;
if ops.GPU
    CC = gpuArray.zeros( Nchan,  Nchan, 'single');
else
    CC = zeros( Nchan,  Nchan, 'single');
end
if strcmp(ops.whitening, 'noSpikes')
    if ops.GPU
        nPairs = gpuArray.zeros( Nchan,  Nchan, 'single');
    else
        nPairs = zeros( Nchan,  Nchan, 'single');
    end
end
if ~exist('DATA', 'var')
    DATA = zeros(NT, rez.ops.Nchan, Nbatch_buff, 'int16');
end

isproc = zeros(Nbatch, 1);
while 1
    ibatch = ibatch + ops.nSkipCov;
    %clc;disp([num2str(ibatch) '/' num2str(Nbatch)])
    progressbar(ibatch/Nbatch,[]);
    offset = max(0, 2*NchanTOT*((NT - ops.ntbuff) * (ibatch-1) - 2*ops.ntbuff));
    if ibatch==1
        ioffset = 0;
    else
        ioffset = ops.ntbuff;
    end
    %fseek(fid, offset, 'bof'); %file already at right position it will be
    %there after each reading 
    %buff = fread(fid, [NchanTOT NTbuff], '*int16');
    %Reading portion of each file based on NTBUFF
    clear buff
    for j=1:96  
        bufftemp= fread(fid{j}, [NTbuff], '*single'); %reading each fil into a temp buffer
        bufftemp=int16(bufftemp*1e6); %converting to uV so can be put in int16 for kilosort
        if isempty(bufftemp) %if empty EOF reached
        break
    end
    buff(j,:)=bufftemp; 
    end
    %         keyboard;
    if isempty(bufftemp)
        break;
    end
    nsampcurr = size(buff,2);
    if nsampcurr<NTbuff
        buff(:, nsampcurr+1:NTbuff) = repmat(buff(:,nsampcurr), 1, NTbuff-nsampcurr);
    end
    if ops.GPU
        dataRAW = gpuArray(buff);
    else
        dataRAW = buff;
    end
    dataRAW = dataRAW';
    dataRAW = single(dataRAW);
    dataRAW = dataRAW(:, chanMapConn);
    datatemp=double(gather(dataRAW));
    %applying comb filter
    datatemp=filtfilt(nb,na,datatemp);
    
%     datr = filter(b1, a1, dataRAW);
%     datr = flipud(datr);
%     datr = filter(b1, a1, datr);
%     datr = flipud(datr);
% New bandpass    
    datr = filter(d, datatemp);
    datr = flipud(datr);
    datr = filter(d, datr);
    datr = flipud(datr);
    datr = single(datr);
    datr =gpuArray(datr);
    
    switch ops.whitening
        case 'noSpikes'
            smin      = my_min(datr, ops.loc_range, [1 2]);
            sd = std(datr, [], 1);
            peaks     = single(datr<smin+1e-3 & bsxfun(@lt, datr, ops.spkTh * sd));
            blankout  = 1+my_min(-peaks, ops.long_range, [1 2]);
            smin      = datr .* blankout;
            CC        = CC + (smin' * smin)/NT;
            nPairs    = nPairs + (blankout'*blankout)/NT;
        otherwise
            CC        = CC + (datr' * datr)/NT;
    end
    
    if ibatch<=Nbatch_buff
        DATA(:,:,ibatch) = gather_try(int16( datr(ioffset + (1:NT),:)));
        %DATA(:,:,ibatch) = gather_try(single( datr(ioffset + (1:NT),:)));
        isproc(ibatch) = 1;
    end
end
CC = CC / ceil((Nbatch-1)/ops.nSkipCov);
switch ops.whitening
    case 'noSpikes'
        nPairs = nPairs/ibatch;
end
fclose all;
fprintf('Time %3.0fs. Channel-whitening filters computed. \n', toc);
switch ops.whitening
    case 'diag'
        CC = diag(diag(CC));
    case 'noSpikes'
        CC = CC ./nPairs;
end

if ops.whiteningRange<Inf
    ops.whiteningRange = min(ops.whiteningRange, Nchan);
    Wrot = whiteningLocal(gather_try(CC), yc, xc, ops.whiteningRange);
else
    %
    [E, D] 	= svd(CC);
    D = diag(D);
    eps 	= 1e-6;
    Wrot 	= E * diag(1./(D + eps).^.5) * E';
end
Wrot    = ops.scaleproc * Wrot;

fprintf('Time %3.0fs. Loading raw data and applying filters... \n', toc);
%Opening all binaries
 if strcmp(event_name,'ML') %gathers all binaries of ML and AL
        index=contains({file_list.name},'xpz5');
        index_files=find(index==1);
        index_files=index_files(1:64);
        index2=contains({file_list.name},'xpz2');
        index_files2=find(index2==1);
        index_files2=index_files2(1:32);
        all_ML=[index_files index_files2];
            for bin_in=1:length(all_ML)
                fid{bin_in}=fopen(fullfile(file_list(all_ML(bin_in)).folder , file_list(all_ML(bin_in)).name));
                fread(fid{bin_in},10,'single'); %leave pointer at beginning of data
                channels_files{bin_in}=file_list(all_ML(bin_in)).name;
            end

    elseif strcmp(event_name,'AL')
        index=contains({file_list.name},'xpz2');
        index_files=find(index==1);
        all_AL=index_files(33:128);
        for bin_in=1:length(all_AL)
                fid{bin_in}=fopen(fullfile(file_list(all_AL(bin_in)).folder , file_list(all_AL(bin_in)).name));
                fread(fid{bin_in},10,'single');
                channels_files{bin_in}=file_list(all_AL(bin_in)).name;
        end
    end
%fid         = fopen(ops.fbinary, 'r');
fidW    = fopen(ops.fproc, 'w');

if strcmp(ops.initialize, 'fromData')
    i0  = 0;
    ixt  = round(linspace(1, size(ops.wPCA,1), ops.nt0));
    wPCA = ops.wPCA(ixt, 1:3);
    
    rez.ops.wPCA = wPCA; % write wPCA back into the rez structure
    uproj = zeros(1e6,  size(wPCA,2) * Nchan, 'single');
end
%
for ibatch = 1:Nbatch
    %clc;disp([num2str(ibatch) '/' num2str(Nbatch)])
    progressbar([],ibatch/Nbatch);
    if isproc(ibatch) %ibatch<=Nbatch_buff
        if ops.GPU
            datr = single(gpuArray(DATA(:,:,ibatch)));
        else
            datr = single(DATA(:,:,ibatch));
        end
    else
        offset = max(0, 2*NchanTOT*((NT - ops.ntbuff) * (ibatch-1) - 2*ops.ntbuff));
        if ibatch==1
            ioffset = 0;
        else
            ioffset = ops.ntbuff;
        end
        %fseek(fid, offset, 'bof');
        for j=1:96  
            bufftemp= fread(fid{j}, [NTbuff], '*single'); %reading each fil into a temp buffer
            bufftemp=int16(bufftemp*1e6);
                if isempty(bufftemp) %if empty EOF reached
                    break
                end
        buff(j,:)=bufftemp; 
        end
        %%%%
       % buff = fread(fid, [NchanTOT NTbuff], '*int16');
        if isempty(bufftemp)
            break;
        end
        nsampcurr = size(buff,2);
        if nsampcurr<NTbuff
            buff(:, nsampcurr+1:NTbuff) = repmat(buff(:,nsampcurr), 1, NTbuff-nsampcurr);
        end
        
        if ops.GPU
            dataRAW = gpuArray(buff);
        else
            dataRAW = buff;
        end
        dataRAW = dataRAW';
        dataRAW = single(dataRAW);
        dataRAW = dataRAW(:, chanMapConn);
        
%         datr = filter(b1, a1, dataRAW);%?
%         datr = flipud(datr);
%         datr = filter(b1, a1, datr);
%         datr = flipud(datr);
        
%         %applying comb filter for 60Hz
%         dataRAW=filtfilt(nb,na,double(dataRAW));
%         dataRAW=single(dataRAW);
% %     datr = filter(b1, a1, dataRAW);
% %     datr = flipud(datr);
% %     datr = filter(b1, a1, datr);
% %     datr = flipud(datr);
% % New bandpass    
%         datr = filter(d, dataRAW);
%         datr = flipud(datr);
%         datr = filter(d, datr);
%         datr = flipud(datr);
        
 datatemp=double(gather(dataRAW));
    %applying comb filter
    datatemp=filtfilt(nb,na,datatemp);
    
%     datr = filter(b1, a1, dataRAW);
%     datr = flipud(datr);
%     datr = filter(b1, a1, datr);
%     datr = flipud(datr);
% New bandpass    
    datr = filter(d, datatemp);
    datr = flipud(datr);
    datr = filter(d, datr);
    datr = flipud(datr);
    datr = single(datr);
    datr =gpuArray(datr);        
        
        
        datr = datr(ioffset + (1:NT),:);
    end
    
    datr    = datr * Wrot;
    
    if ops.GPU
        dataRAW = gpuArray(datr);
    else
        dataRAW = datr;
    end
    %         dataRAW = datr;
    dataRAW = single(dataRAW);
    dataRAW = dataRAW / ops.scaleproc;
    
    if strcmp(ops.initialize, 'fromData') %&& rem(ibatch, 10)==1
            % find isolated spikes
            [row, col, mu] = isolated_peaks(dataRAW, ops.loc_range, ops.long_range, ops.spkTh);

            % find their PC projections
            uS = get_PCproj(dataRAW, row, col, wPCA, ops.maskMaxChannels);

            uS = permute(uS, [2 1 3]);
            uS = reshape(uS,numel(row), Nchan * size(wPCA,2));

            if i0+numel(row)>size(uproj,1)
                uproj(1e6 + size(uproj,1), 1) = 0;
            end

            uproj(i0 + (1:numel(row)), :) = gather_try(uS);
            i0 = i0 + numel(row);
    end
    
    if ibatch<=Nbatch_buff
        DATA(:,:,ibatch) = gather_try(datr);
    else
        datcpu  = gather_try(int16(datr));
        fwrite(fidW, datcpu, 'int16');
    end
    
end

if strcmp(ops.initialize, 'fromData')
   uproj(i0+1:end, :) = []; 
end
Wrot        = gather_try(Wrot);
rez.Wrot    = Wrot;

fclose(fidW);
fclose all;
if ops.verbose
    fprintf('Time %3.2f. Whitened data written to disk... \n', toc);
    fprintf('Time %3.2f. Preprocessing complete!\n', toc);
end


rez.temp.Nbatch = Nbatch;
rez.temp.Nbatch_buff = Nbatch_buff;
close;

