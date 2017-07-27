function tankMetaData(tank_path, block_num)
%% get raw metadata
raw = tank_trial_info(tank_path, block_num);
max_joystick_records = 5; % num times to record joystick position
meta.trial = [];

hold on;
plot(raw.trial_on(1:1e7));
plot(raw.joystick(1:1e7));

%% initialize matrix with trial times
trial_on = raw.trial_on > 1e6;
if any(trial_on) % there are multiple trials
    trial_toggle = trial_on(1);
    temp_samp = 1;
    for t = 1:length(trial_on)
        trial_val = trial_on(t);
        if trial_toggle == 1 && trial_val == 0
            trial_toggle = 0;
            meta.trial = [meta.trial; [temp_samp t NaN(1,8)]];
        elseif trial_toggle == 0 && trial_val == 1
            trial_toggle = 1;
            temp_samp = t-1;
        end
    end
else % there is only one trial
    meta.trial = [0 find(raw.trial_on < 3e5,1,'first') NaN(1,8)];
end

%% get sound stimulus times

%% get joystick times and directions
if max_joystick_records ~= 0
    meta.joystick = NaN(size(meta.trial,1), 2*max_joystick_records);
    for trial = 1:size(meta.trial,1)
        t_init = meta.trial(trial,1);
        snip = raw.joystick(t_init:(meta.trial(trial,2)));
        snip = (snip > 1.5e6) + (snip > 0.5e6); % converts to matrix of 0,1,2

        joystick_pos = snip(1); % store current position
        meta.joystick(trial,1) = t_init;
        meta.joystick(trial,2) = joystick_pos;
        
        if max_joystick_records ~= 1
            j_num = 2; % incremented on each joystick movement
            for t_rel = 1:length(snip)
                trial_val = snip(t_rel);
                if joystick_pos ~= trial_val
                    joystick_pos = trial_val;
                    meta.joystick(trial,2*j_num-1) = t_rel + t_init - 1;
                    meta.joystick(trial,2*j_num) = joystick_pos;
                    j_num = j_num + 1;
                    if j_num > max_joystick_records
                        break
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
    t_init = meta.trial(trial,1);
    snip = raw.reward(t_init:(meta.trial(trial,2))) > 1e6;
    
    if any(snip) % there was a reward
        reward_toggle = snip(1);
        temp_samp = 1;
        r_num = 1; % incremented based on reward number of 3
        for t_rel = 1:length(snip)
            trial_val = snip(t_rel);
            if reward_toggle == 1 && trial_val == 0
                reward_toggle = 0;
                meta.trial(trial,2*r_num+3) = temp_samp + t_init - 1;
                meta.trial(trial,2*r_num+4) = t_rel + t_init - 1;
                r_num = r_num + 1;
                if r_num == 4
                    break
                end
            elseif reward_toggle == 0 && trial_val == 1
                reward_toggle = 1;
                temp_samp = t_rel-1;
            end
        end
    end
end

end