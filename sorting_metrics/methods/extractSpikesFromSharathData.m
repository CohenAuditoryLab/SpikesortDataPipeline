function [spike_times, spike_clusters] = extractSpikesFromSharathData(data_file)
    % data_file should be the path to the CohenNeurons.mat file
    % OUTPUT
        % spike_times => vector of spike times in ms
        % spike_clusters => neuron ID assignments of spikes
    bin_length = 1;
    trial_length = 2000;
    CohenNeurons = load(data_file);
    CohenNeurons = CohenNeurons.CohenNeurons;
    % Number of neurons
    num_neurons = 16;
    num_trials = 464;
    % Pre-define binranges from 0 to 2000ms
    binranges = linspace(0,trial_length,trial_length/bin_length+1);
    % For each neuron...
    all_spikes_labels_array = [];
    all_spikes_labels_array = reshape(all_spikes_labels_array, [0,2]);
    for i = 1:num_neurons
        % For each trial...
        spikes_array = [];
        spikes_array = reshape(spikes_array, [0,1]);
        for j = 1:num_trials
            spikes_array = vertcat(spikes_array, CohenNeurons(i).trials(j).spikes.');
            label = zeros(size(spikes_array,1), 1); label(:) = CohenNeurons(i).ID;
            spikes_labels_array = horzcat(spikes_array, label);
        end
        all_spikes_labels_array = vertcat(all_spikes_labels_array, spikes_labels_array);
    end
    spike_times = all_spikes_labels_array(:,1);
    spike_clusters = all_spikes_labels_array(:,2);
end