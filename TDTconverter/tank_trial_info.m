function meta=tank_trial_info(tank_path,block_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extracts continous waveforms from analog signals
%Input: 
%           tank_path     : Folder where the tank is located
%           block_number  : Number of block to process
%
%Output
%meta: Structure containing
%           reward        : pulse to juicer (when pulse high juice on)
%           joystick      : signal acquired from joystick (left and right
%           trial_on      : signal that indicates trial start and end
%           sound_stimuli : sound being played to the speakers
%           triggers      : If Dynamic Moving Ripple or vocalizations are being played this waveform will have triggers


full_path=fullfile(tank_path,['Block-' num2str(block_number)]); %So you are happy I'm using fullfile.....
temp=SEV2mat(full_path,'Channel',131,'EVENTNAME','xpz2');
meta.reward=temp.xpz2.data;clear temp
temp=SEV2mat(full_path,'Channel',132,'EVENTNAME','xpz2');
meta.joystick=temp.xpz2.data;clear temp
temp=SEV2mat(full_path,'Channel',134,'EVENTNAME','xpz2');
meta.trial_on=temp.xpz2.data;clear temp
temp=SEV2mat(full_path,'Channel',65,'EVENTNAME','xpz5');
meta.sound_stimuli =temp.xpz5.data;clear temp
temp=SEV2mat(full_path,'Channel',66,'EVENTNAME','xpz5');
meta.triggers =temp.xpz5.data;clear temp
end