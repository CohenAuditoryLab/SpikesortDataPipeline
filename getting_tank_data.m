function [spikedata]=getting_tank_data(tank_folder)

fs=24414.0625;
[b,a] = butter(4, [0.02 0.5]);
for n=1:64

[data]=SEV2mat([tank_folder '\Block-3'],'CHANNEL',n,'EVENTNAME','xpz2');
spikes(n).spikes_ML=double(data.xpz2.data);
spikes(n).spikes_MLf=filtfilt(b,a,spikedata(n).spikes_ML);

[data]=SEV2mat([tank_folder '\Block-3'],'CHANNEL',n,'EVENTNAME','xpz5');
spikedata(n).spikes_AL=double(data.xpz5.data);
spikedata(n).spikes_ALf=filtfilt(b,a,spikedata(n).spikes_AL);
fs=data.xpz5.fs;
clear data
%save as pream different files same variable cont_wave.raw
end


