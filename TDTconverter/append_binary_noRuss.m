function append_binary_noRuss(n,tankBlockFolder, fpath)

%getting filename from tank folder
indext=findstr(tankBlockFolder,'\');
file_name=[tankBlockFolder(indext(end-1)+1:indext(end)-1) '_' tankBlockFolder(indext(end)+1:end)];
%Building string to open file for reading
%tempch=fopen([tank_folder '\' blockstr '\' file_name '_' blockstr '_' ampvar '_ch' num2str(n) '.sev']);
%tempch = fopen(['D:\SpikeSortingPipeline\Tanks\SAM-171013\Block-3\SAM-171013_block-3_xpz2_ch' num2str(conta) '.sev']);
tempch=fopen([tankBlockFolder filesep file_name '_xpz2_ch' num2str(n) '.sev']);
fread(tempch,10,'single');%skipping header
a=fread(tempch,inf,'*single');%reading waveform
tempbin=fopen([fpath '.dat'],'a');
fwrite(tempbin,a*1e6,'int16');
fclose all;
clear a tempch

% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180102', 2, 'xpz2', 96, 0, 0, 0, 'H:\Test_180102_AL');
% getting_tank_data_binary(tank_folder,block,preamp_var,number_channels,notch_filter,band_filter,artifact,fpath)