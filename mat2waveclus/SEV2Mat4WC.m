function SEV2Mat4WC(tankDirectory, blockNames, outputDirectory, numChannels)
    % SEV2Mat4WC - run WaveClus on TDT tanks
    % input
        % tankDirectory
            % (string) path of your tank
            % e.g. - 'D:\SpikeSortingPipeline\Tanks\Domo\Domo'
        % blockNames 
            % (1xN vector) a vector of block names within your tank
            % e.g. -  {'20180807_ABBA_d01', '20180807_Ripple2_d01', '20180807_Vocalization_d01'}
        % outputDirectory
            % (string) the directory where WaveClus output should be saved 
            % e.g. - 'H:\Domo'
        % numChannels
            % (integer) number of channels in your data
    % set parameters to what FCampos does
    param.stdmin = 4;
    param.min_clus=60;
    param.max_spk=50000;
    param.matxtamp=0.251;
    param.matxtamp=0.251;
    currentPath = pwd;
    for f =1:numel(blockNames)
        if (exist([outputDirectory filesep blockNames{f}], 'dir') == 0)
             mkdir([outputDirectory filesep blockNames{f}]);
        end
        cd([outputDirectory filesep blockNames{f}]);
        for i=1:numChannels
            % convert tank data to matlab files
            data = SEV2mat([tankDirectory filesep blockNames{f}],'CHANNEL',i);
            sr=data.Wav1.fs;
            data= data.Wav1.data;
            savePath = [outputDirectory filesep blockNames{f} '\ch' num2str(i) '.mat'];
            save(savePath,'sr','data','-v7.3');
            % get spikes from waveclus
            Get_spikes(savePath,'parallel',true,'par',param);
            spikesPath = [outputDirectory filesep blockNames{f} '\ch' num2str(i) '_spikes.mat'];
            % cluster spikes with waveclus
            Do_clustering([outputDirectory filesep blockNames{f} '\ch' num2str(i) '_spikes.mat'], 'parallel', true, 'par', param);
        end
    end
    cd(currentPath);
end
