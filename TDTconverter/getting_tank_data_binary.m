function [spike_waves]=getting_tank_data_binary(tank_folder,block,preamp_var,number_channels,notch_filter,band_filter,artifact,fpath)
tic;
if nargin<4
   notch_filter=64; 
end
if nargin<5
   notch_filter=0; 
end
if nargin<6
   band_filter=0; 
end
if nargin<7
   band_filter=0; 
end
if nargin<8
   artifact=0; 
end
block_str=['Block-' num2str(block)];
if ~isdir([tank_folder '\' block_str])
    error('not a valid tank/block folder')
end
if ~exist(fpath, 'dir')
    mkdir(fpath); 
end
if number_channels==64 %&& strcmp(preamp_var,'xpz5'); either var only has 64 channels
   for n=1:number_channels
       [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME',preamp_var);
       spike_waves(n,:)=double(data.(preamp_var).data);
       fs=data.(preamp_var).fs;
   end
elseif number_channels==96 && strcmp(preamp_var,'xpz5') % 96 channels 64 in xpz5+ 1 to 32 in xpz2 
    for n=1:64
        %[data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME',preamp_var);
        %spike_waves(n,:)=double(data.(preamp_var).data);
        %fs=data.(preamp_var).fs;
        %append_binary(tank_folder,blockstr,n,'xpz5');
        append_binary(tank_folder,block_str,n,'xpz5',fpath);
   end
        counter=65;
        %wave_end=length(spike_waves); 
   for n=1:32 %last 32 channels are in xpz2 variable
%         [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME','xpz2');
%         pad = length(spike_waves)-length(data.xpz2.data);
%         if pad>0 %for some reason length of blocks in both processor sometimes is not the same, forcing same length
%             tempdata=double(data.xpz2.data);
%             spike_waves(counter,:)=[tempdata zeros(1,pad)];
%         elseif pad<0
%             spike_waves(counter,:)=data.xpz2.data(1:wave_end);
%         elseif pad==0
%             spike_waves(counter,:)=data.xpz2.data;
%         end
        append_binary(tank_folder,block_str,n,'xpz2',fpath);
        %counter=counter+1;
   end     
elseif number_channels==96 && strcmp(preamp_var,'xpz2') % 96 channels in xpz2 starting at 33 goes to 128
    counter=33;
     for n=1:96
%         [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',counter,'EVENTNAME','xpz2');
%         spike_waves(n,:)=double(data.(preamp_var).data);
%         fs=data.(preamp_var).fs;
        append_binary(tank_folder,block_str,counter,'xpz2',fpath);
        counter=counter+1;
     end
   
elseif number_channels<64
    for n=1:number_channels
        [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME',preamp_var);
        spike_waves(n,:)=double(data.(preamp_var).data);
        fs=data.(preamp_var).fs;
    end    
    
    
end
%Applyng 60Hz notch filter
if notch_filter
    [b,a] = butter(3, [50/(fs/2) 70/(fs/2)],'stop'); %20Hz bandwidth centered at 60Hz (50-70)
        for n=1:size(spike_waves,1)
            spike_waves(n,:)=filtfilt(b,a,spike_waves(n,:));
        end
end
%Applying Band Pass   
if band_filter
    [d,c] = butter(3, [244/(fs/2) 6.104e3/(fs/2)]); %bandpass filter
        for n=1:size(spike_waves,1)
            spike_waves(n,:)=filtfilt(d,c,spike_waves(n,:));
        end
end    
%Removing mostly large spikes due to movement
%Threshold at 60% of max will need to check when back to PZ5 PZ2
%combination
if artifact
      for n=1:size(spike_waves,1)
          spike_waves(n,:)=artifactThresh(spike_waves(n,:),1,std(spike_waves(n,:))*6.5);%Threshold 6.50 std
      end
end
%disp([num2str(size(spike_waves,1)) ' Channels read']);
fprintf('Time %3.2f. Reading data done!\n', toc);
% temp= strfind(tank_folder,'\');
% filename=[tank_folder(temp(end)+1:end) '_b' num2str(block) fpath(end-2:end) '.dat'];
% fidW = fopen(fullfile(fpath, filename), 'w', 'l');
% fwrite(fidW,spike_waves.*1e6, 'int16'); %changing formating for microvolts
% %fwrite(fidW,spike_waves, 'double');
% fclose(fidW);
end
