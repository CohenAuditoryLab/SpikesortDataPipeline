function [spike_times, spike_clusters] = extractSpikesFromICdata(data_file)
load(data_file, 'Data');
result = [];
for i =1:numel(Data)
    a = Data(i).SnipTimeStamp;
    a = reshape(a,[numel(a),1]);
    b = zeros(numel(a),1);
    b(1:end) = i;
    c = horzcat(b,a);
    result = vertcat(result, c);
end
spike_clusters = result(:,1);
spike_times = result(:,2);
end