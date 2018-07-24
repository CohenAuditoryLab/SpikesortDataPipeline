function append_binary(tank_folder,blockstr,n,ampvar,fpath)
%Data is scaled in clean_files. no need to scale anymore.

%getting filename from tank folder
indext=findstr(tank_folder,'\');
file_name=tank_folder(indext(end)+1:end);

%Building string to open file for reading
tempch=fopen([tank_folder '\' blockstr '\' file_name '_' blockstr '_' ampvar '_ch' num2str(n) '.sev']);
%tempch = fopen(['D:\SpikeSortingPipeline\Tanks\SAM-171013\Block-3\SAM-171013_block-3_xpz2_ch' num2str(conta) '.sev']);
%fread(tempch,10,'single');%skipping header
a=fread(tempch,inf,'*int16');%reading waveform
tempbin=fopen([fpath '.dat'],'a');
fwrite(tempbin,a,'int16');
fclose all;
tempbin=fopen([fpath 'tr.dat'],'a');
fwrite(tempbin,a','int16');
clear a tempch




% fread(tempch,10,'single');%skipping header
% a=fread(tempch,inf,'*single');%reading waveform
% tempbin=fopen([fpath '.dat'],'a');
% fwrite(tempbin,a*1e9,'int16');
% fclose all;
% tempbin=fopen([fpath 'tr.dat'],'a');
% fwrite(tempbin,a*1e9,'int16');
% clear a tempch

% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180102', 2, 'xpz2', 96, 0, 0, 0, 'H:\Test_180102_AL');
% getting_tank_data_binary(tank_folder,block,preamp_var,number_channels,notch_filter,band_filter,artifact,fpath)