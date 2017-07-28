function meta = tankMetaData(tank_path, block_num)
%tankMetaData Returns metadata for the specified tank/block pair.
%   meta.trials: each row is a trial; the first two columns are the
%   absolute start and stop time of the trial; the next pair are the
%   absolute start and stop time of the sound stimulus; the last six
%   columns are three pairs of start and stop times corresponding to the
%   three rewards given; if no rewards are given, these values are NaN
%   
%   meta.joystick: each row is a trial, columns are in pairs, with the
%   first column (odd numbered) being the absolute time of sampling and the
%   second column (even numbered) being the position of the joystick at the
%   sample time (0 center, 1 left, 2 right); values default to NaN

%% get raw metadata
raw = tank_trial_info(tank_path, block_num);
max_joystick_records = 5; % num times to record joystick position
meta.trial = [];

%% initialize matrix with trial times
trial_on = raw.trial_on > 1e6;
if any(trial_on) % there are multiple trials
    trial_toggle = trial_on(1); % toggle on when trial is on
    temp_samp = 1;
    for t = 1:length(trial_on)
        trial_val = trial_on(t);
        if trial_toggle == 1 && trial_val == 0
            trial_toggle = 0;
            meta.trial = [meta.trial; [temp_samp t NaN(1,8)]]; % initialize
        elseif trial_toggle == 0 && trial_val == 1
            trial_toggle = 1;
            temp_samp = t-1;
        end
    end
else % there is only one trial (single trials have a different threshold)
    meta.trial = [0 find(raw.trial_on < 3e5,1,'first') NaN(1,8)]; % initialize
end

%% get sound stimulus times

%% get joystick times and directions
if max_joystick_records ~= 0 % do not parse for joystick records if 0
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
else
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
            if reward_toggle == 1 && trial_val == 0
                reward_toggle = 0; % toggle off when reward is not being given
                
                % reward start and end, convert to absolute time
                meta.trial(trial,2*r_num+3) = temp_samp + t_init - 1; 
                meta.trial(trial,2*r_num+4) = t_rel + t_init - 1;
                
                r_num = r_num + 1;
                if r_num == 4
                    % do not record any more rewards for this trial
                    break;
                end
            elseif reward_toggle == 0 && trial_val == 1
                reward_toggle = 1; % toggle on when reward is being given
                temp_samp = t_rel - 1;
            end
        end
    end
end

end
