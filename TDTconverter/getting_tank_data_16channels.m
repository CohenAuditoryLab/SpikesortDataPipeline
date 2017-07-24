function [spike_waves]=getting_tank_data_16channels(tank_folder,block,preamp_var,number_channels,notch_filter,band_filter,artifact,fpath,index_chan)
tic;
if nargin<4
   notch_filter=64; 
end
if nargin<5
   notch_filter=0; 
end
if nargin<6
   band_filter=0'; 
end
if nargin<7
   band_filter=0'; 
end
if nargin<8
   artifact=0'; 
end
block_str=['Block-' num2str(block)];
if ~isdir([tank_folder '\' block_str])
    error('not a valid tank/block folder')
end

if ~exist(fpath, 'dir')
    mkdir(fpath); 
end
index_channels=[1 17 33 49 65 81 ];
if number_channels==96 && strcmp(preamp_var,'xpz5') % 96 channels 64 in xpz5+ 1 to 32 in xpz2 
    counter=1;
    for n=index_channels(index_chan):index_channels(index_chan)+15
        [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME',preamp_var);
        spike_waves(counter,:)=double(data.(preamp_var).data);
        fs=data.(preamp_var).fs;
        counter=counter+1;
    end
elseif  number_channels==96 && index_chan>4 && strcmp(preamp_var,'xpz5')      
        
        wave_end=length(spike_waves); 
   
        if index_chan==5
            counter=1;
            for n=1:16 %last 32 channels are in xpz2 variable
                [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME','xpz2');
                pad = length(spike_waves)-length(data.xpz2.data);
                if pad>0 %for some reason length of blocks in both processor sometimes is not the same, forcing same length
                    tempdata=double(data.xpz2.data);
                    spike_waves(counter,:)=[tempdata zeros(1,pad)];
                elseif pad<0
                    spike_waves(counter,:)=double(data.xpz2.data(1:wave_end));
                end
                counter=counter+1;
            end   
        elseif index_chan==6
            counter=1;
            for n=17:32 %last 32 channels are in xpz2 variable
                [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME','xpz2');
                pad = length(spike_waves)-length(data.xpz2.data);
                if pad>0 %for some reason length of blocks in both processor sometimes is not the same, forcing same length
                    tempdata=double(data.xpz2.data);
                    spike_waves(counter,:)=[tempdata zeros(1,pad)];
                elseif pad<0
                    spike_waves(counter,:)=double(data.xpz2.data(1:wave_end));
                end
                counter=counter+1;
            end 
        end
            
            
            
            
        
        
        
elseif number_channels==96 && strcmp(preamp_var,'xpz2') % 96 channels in xpz2 starting at 33 goes to 128
    counter=1;
    for n=index_channels(index_chan):index_channels(index_chan)+15
        [data]=SEV2mat([tank_folder '\' block_str],'CHANNEL',n,'EVENTNAME','xpz2');
        spike_waves(counter,:)=(data.(preamp_var).data);
        fs=data.(preamp_var).fs;
        counter=counter+1;
    end
    
    
end
%Applyng 60Hz notch filter
if notch_filter
    [b,a] = butter(3, [50/(fs/2) 70/(fs/2)],'stop'); %20Hz bandwidth centered at 60Hz (50-70)
        for n=1:size(spike_waves,1)
            spike_waves(n,:)=single(filtfilt(b,a,double(spike_waves(n,:))));
        end
end
%Applying Band Pass   
if band_filter
    [d,c] = butter(3, [244/(fs/2) 6.104e3/(fs/2)]); %bandpass filter
        for n=1:size(spike_waves,1)
            spike_waves(n,:)=single(filtfilt(d,c,double(spike_waves(n,:))));
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
spike_waves=single(spike_waves);
disp([num2str(size(spike_waves,1)) ' Channels read']);
fprintf('Time %3.2f. Reading data done!\n', toc);
temp= strfind(tank_folder,'\');
channels={'_ch1_16','ch17_32','ch33_48','ch49_64','ch65_80','ch81_96'};
filename=[tank_folder(temp(end)+1:end) '_block-' num2str(block) channels{index_chan} '_binary.dat'];
fidW = fopen(fullfile(fpath, filename), 'w');
fwrite(fidW,spike_waves, 'int16');
fclose(fidW);
end