function fig = createClusterGrid(fig,out,param,clustNum)
%createClusterGrid Update the provided figure with a grid of clustNum graphs.

extractSpk = (clustNum == out.spikeClusters(:,1));
spk = param.peakSpikes(extractSpk,:);
figure(fig);

%% bar graph of channels
subplot(2,2,1);
cla;
chans = tabulate(out.peakChannel(extractSpk)); % frequency table
chans = chans(chans(:,3) > 0,:); % remove frequencies of 0
bar(chans(:,1),rdivide(chans(:,3),100),1.0,'b');
title(['Cluster ' num2str(clustNum-1) ': Sources of ', num2str(sum(chans,2)), ' Spikes']);
xlabel('channel number');
ylabel('relative frequency');

%% initialize waveform graphs

% centered around spike time 
subplot(2,2,2);
cla;
hold on;
title(['Cluster ' num2str(clustNum-1) ': Raw Data']);
axis([param.view_win_fac(1) param.view_win_fac(end) -175 175]);
xlabel('time since spike detection (ms)');

% centered around min
subplot(2,2,3);
cla;
hold on;
title(['Cluster ' num2str(clustNum-1) ': Centered to Min']);
axis([param.view_win_fac(1) param.view_win_fac(end) -175 175]);
xlabel('time since spike min (ms)');
% intialize average matrix, first col is running total, second is number of entries
min_avg = zeros(size(param.view_win,2),2);

% centered around max
subplot(2,2,4);
cla;
hold on;
title(['Cluster ' num2str(clustNum-1) ': Centered to Max']);
axis([param.view_win_fac(1) param.view_win_fac(end) -175 175]);
xlabel('time since spike max (ms)');
% intialize average matrix, first col is running total, second is number of entries
max_avg = zeros(size(param.view_win,2),2);

%% plot each spike individually
for j = 1:(size(spk,1))
    y_axis = squeeze(spk(j,:));

    % shift graphs along x-axis
    [~,minInd] = min(y_axis);
    x_axis_min = param.sample_win_fac-param.sample_win_fac(minInd);
    min_indices = param.view_win + minInd;
    [~,maxInd] = max(y_axis);
    x_axis_max = param.sample_win_fac-param.sample_win_fac(maxInd);
    max_indices = param.view_win + maxInd;

    % update average waveform data
    for k = 1:size(param.view_win,2)
        if (min_indices(k) > 0) & (min_indices(k) < size(y_axis,2))
            min_avg(k,1) = min_avg(k,1) + y_axis(min_indices(k)); % add to running total
            min_avg(k,2) = min_avg(k,2) + 1; % added an element
        end
        if (max_indices(k) > 0) & (max_indices(k) < size(y_axis,2))
            max_avg(k,1) = max_avg(k,1) + y_axis(max_indices(k)); % add to running total
            max_avg(k,2) = max_avg(k,2) + 1; % added an element
        end
    end

    % plot shifted waveforms
    subplot(2,2,2);
    plot(param.sample_win_fac,y_axis,'r');
    subplot(2,2,3);
    plot(x_axis_min,y_axis,'r');
    subplot(2,2,4);
    plot(x_axis_max,y_axis,'r');
end

%% overlay average waveforms
subplot(2,2,2);
plot(param.sample_win_fac,mean(spk),'k','LineWidth',3);
subplot(2,2,3);
plot(param.view_win_fac,rdivide(min_avg(:,1),min_avg(:,2)),'k','LineWidth',3);
subplot(2,2,4);
plot(param.view_win_fac,rdivide(max_avg(:,1),max_avg(:,2)),'k','LineWidth',3);

end