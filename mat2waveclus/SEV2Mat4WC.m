% set parameters to what FC does
param.stdmin = 4;
param.stdmin=stdmin;
param.min_clus=60;
param.max_spk=50000;
param.matxtamp=0.251;
param.matxtamp=0.251;
stdmin=4;
% set file names for Domo
fileNames = {'20180709_ABBA_d02', '20180711_ABBA_d01', '20180711_Ripple2_d01', '20180711_TuningTest_d01','20180711_Vocalization_d01'};
currentPath = pwd;
for f =1:5
    cd(['H:\Domo\' fileNames{f}]);
    for i=1:16
        % convert tank data to matlab files
        data = SEV2mat(['D:\SpikeSortingPipeline\Tanks\Domo\' fileNames{f}],'CHANNEL',i);
        sr=data.Wav1.fs;
        data= data.Wav1.data;
        savePath = ['H:\Domo\' fileNames{f} '\ch' num2str(i) '.mat'];
        save(savePath,'sr','data','-v7.3');
        % get spikes from waveclus
        Get_spikes(savePath,'parallel',true,'par',param);
        spikesPath = ['H:\Domo\' fileNames{f} '\ch' num2str(i) '_spikes.mat'];
        % cluster spikes with waveclus
        Do_clustering(['H:\Domo\' fileNames{f} '\ch' num2str(i) '_spikes.mat'], 'parallel', true, 'par', param);
    end
end
cd(currentPath);
