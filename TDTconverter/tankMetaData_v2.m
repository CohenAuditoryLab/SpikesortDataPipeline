function [meta,lv_file] = tankMetaData_v2(tank_path, block_num, task, chan_num, lv_path)
%tankMetaData Returns metadata for the specified tank/block pair.
%   INPUTS:
%   tank_path: path to tank folder
%   block_num: block number
%   task: either 'Textures', 'STRF', or 'VOC'
%   chan_num: number of channels
%   lv_path: path to LabVIEW data file
%   
%   OUTPUTS:
%   meta.info.task: the string representation of the task
%   meta.info.chan_num: the number of channels recorded
%
%   meta.trials: each row is a trial; the first two columns are the
%   start and stop time of the trial in samples and the last six
%   columns are three pairs of start and stop times corresponding to the
%   three rewards given; if no rewards are given, these values are NaN
%
%   meta.sound: each row represents a trial for Textures blocks or a single
%   sound for STRF and VOC blocks, the col 1 is the start time in samples,
%   col 2 is the stop time in samples, col3 is the start of BAD token in
%   samples
%   
%   meta.joystick: each row is a trial; columns are in pairs, with the
%   first column (odd numbered) being the absolute time of sampling and the
%   second column (even numbered) being the position of the joystick at the
%   sample time (0 center, 1 left, 2 right); values default to NaN

%% get raw metadata
raw = tank_trial_info(tank_path, block_num);
max_joystick_records = 5; % num times to record joystick position
meta.trial = [];
meta.sound = [];
meta.info.task = task;
meta.info.chan_num = chan_num;
if nargin > 4
    lv_file = load(lv_path);
    field = fieldnames(lv_file);
    lv_file = lv_file.(field{1});
end
%trial_on = raw.trial_on > (0.9*max(raw.trial_on));

%% initialize matrix with trial times
if strcmp(task,'Textures')
    %trial_on = raw.trial_on > (0.9*max(raw.trial_on));
    trial_on = raw.trial_on > 3.5;
    trial_toggle = trial_on(1); % toggle on when trial is on
    temp_samp = 1;
    for t = 1:length(trial_on)
        trial_val = trial_on(t);
        if trial_toggle && ~trial_val % if a trial ended
            trial_toggle = 0;
            meta.trial = [meta.trial; [temp_samp t NaN(1,8)]]; % initialize 
            
        elseif ~trial_toggle && trial_val && trial_on(t+100) %if trial started
            %disp()
            %if (t - meta.trial(end,2) > 94146) % if the time between trials is greater than 3.9 seconds * sampling rate (24140)
                trial_toggle = 1;
                temp_samp = t-1;
            %end
        end
    end
else % there is only one trial (single trials have a different threshold)
    meta.trial = [1 find(raw.trial_on < 3e5,1,'first') NaN(1,8)]; % initialize
end
a = 1;
if length(meta.trial)<length(lv_file)
    lv_file=lv_file(end-length(meta.trial)+1:end);
end

%% get sound stimulus times
if strcmp(task,'Textures')
    meta.sound = cell2mat([{lv_file.StimulusOn}' {lv_file.TimeStamp}']);
    meta.sound(meta.sound(:,2) == -1,2) = NaN;
    temp=meta.sound;
    temp(:,2)=meta.sound(:,3);
    temp(:,3)=meta.sound(:,2);
    meta.sound=temp;clear temp
    meta.sound=meta.sound(:,1:3);
    meta.sound = round(meta.sound * 24.14) + [meta.trial(:,1) meta.trial(:,1) meta.trial(:,1)];
    meta.param = {lv_file.CurrentParam};
    meta.error = cell2mat({lv_file.Error}');
else % 'STRF' or 'VOC'
    sound = (raw.triggers > 4); %2e6);   %% 9/7/2017 - triggers are now all between 1 and 5
    sound_toggle = 0;
    for t = 1:length(raw.triggers)
        sound_val = sound(t);
        if ~sound_toggle && sound_val
            if ~isempty(meta.sound) 
                meta.sound(end,end) = t;
            end
            meta.sound = [meta.sound; t NaN];
            sound_toggle = 1;
        elseif sound_toggle && ~sound_val
            sound_toggle = 0;
        end
    end
    meta.sound = meta.sound(1:(end-1),:);
    if strcmp(task,'STRF') && length(meta.sound) > 2
        meta.sound = [meta.sound(1,:); meta.sound(3:end,:)];
        meta.sound(1,2) = meta.sound(2,1);
    end
end

%% get joystick times and directions
if max_joystick_records ~= 0 && strcmp(task,'Textures')
    meta.joystick = NaN(size(meta.trial,1), 2*max_joystick_records); % initialize
    for trial = 1:size(meta.trial,1)
        t_init = meta.trial(trial,1); % used for time conversion
        snip = raw.joystick(t_init:(meta.trial(trial,2))); % snip times within trial
        snip = (snip > 1.5e6) + (snip > 0.5e6); % converts to matrix of 0,1,2

        joystick_pos = snip(1); % store current position
        meta.joystick(trial,1) = t_init; % time of position record
        meta.joystick(trial,2) = joystick_pos; % corresponding position
        
        if max_joystick_records ~= 1
            j_num = 2; % incremented on each joystick movement
            for t_rel = 1:length(snip)
                trial_val = snip(t_rel);
                if joystick_pos ~= trial_val
                    joystick_pos = trial_val; % update with new position
                    meta.joystick(trial,2*j_num-1) = t_rel + t_init - 1; % convert to absolute time
                    meta.joystick(trial,2*j_num) = joystick_pos; % record new position
                    j_num = j_num + 1;
                    if j_num > max_joystick_records
                        % do not record any more joystick movements for this trial
                        break;
                    end
                end
            end
        end
        
    end
else % no joystick movements to record, or not required by task
    meta.joystick = [];
end

%% get reward time triplets
for trial = 1:size(meta.trial,1)
    t_init = meta.trial(trial,1); % used for time conversion
    snip = raw.reward(t_init:(meta.trial(trial,2))) > 1e6; % snip times within trial
    
    if any(snip) % there were rewards
        reward_toggle = snip(1);
        temp_samp = 1;
        r_num = 1; % incremented based on reward number of 3
        for t_rel = 1:length(snip)
            trial_val = snip(t_rel);
            if reward_toggle && ~trial_val
                reward_toggle = 0; % toggle off when reward is not being given
                
                % reward start and end, convert to absolute time
                meta.trial(trial,2*r_num+1) = temp_samp + t_init - 1; 
                meta.trial(trial,2*r_num+2) = t_rel + t_init - 1;
                
                r_num = r_num + 1;
                if r_num == 4
                    % do not record any more rewards for this trial
                    break;
                end
            elseif ~reward_toggle && trial_val
                reward_toggle = 1; % toggle on when reward is being given
                temp_samp = t_rel - 1;
            end
        end
    end
end

end
