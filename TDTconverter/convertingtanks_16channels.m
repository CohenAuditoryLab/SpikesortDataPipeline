%[~,~,raw]=xlsread('C:\work\Penn\sorting\SAM_master_list');
load('D:\SpikeSortingPipeline\Code\TDTconverter\SAM_master_list.mat');
% task={'STRF','STRF5m','VOC'};
task={'Textures'};
datapath='D:\SpikeSortingPipeline\Tanks\';
outpath='D:\SpikeSortingPipeline\ToSort\';
%XPZ5->ML
%XPZ2->AL
for exp=18:27
    index=find(cell2mat(raw(:,1))==exp);
 for taskindex=1:length(index)
    index2=find(strcmp([raw(index,7)],task{taskindex})==1);
    tankfile=char(raw(index(index2),4));
    blocknum=cell2mat(raw(index(index2),6));
    numchannels=cell2mat(raw(index(index2),8));
    
    for z=1:6
        %AL
        outp=[outpath tankfile '_AL'];
        getting_tank_data_16channels([datapath tankfile],blocknum,'xpz2',96,1,1,1,outp,z);
        %ML
        outp=[outpath tankfile '_ML'];
        getting_tank_data_16channels([datapath tankfile],blocknum,'xpz5',96,1,1,1,outp,z);
    end
 end
    
end
