cd('D:\SpikeSortingPipeline\Code');
num_channels=96;
% tank='SAM-180223';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=3;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);

% tank='SAM-180114';
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=3;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);


tank = 'SAM-180615';
block = 1;
getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\Brianna\' tank '_b' num2str(block) '_AL']);
getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\Brianna\' tank '_b' num2str(block) '_ML']);


% chan_num=96; 
% %batching
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-180114\Block-2';
% fpath='h:\SAM-180114_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-180114\Block-3';
% fpath='h:\SAM-180114_Block-3\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% %using full file
% cd('D:\SpikeSortingPipeline\Code');
% 
%  for t=-3.5:-.5:-5
%  tank='SAM-171027';
% block=1;
%  matToKiloSortsd(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_sd_' num2str(t*100) '_AL\'], 96,t);
%  matToKiloSortsd(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_sd_' num2str(t*100) '_ML\'], 96,t);
%  end
% 

% tank='SAM-180218';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=3;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=4;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);





% for t=3:.25:5
% tank='SAM-180212';
% block=1;
% matToKiloSortsd(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_sd_' num2str(t*100) '_AL\'], 96,t*-1);
% matToKiloSortsd(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_sd_' num2str(t*100) '_ML\'], 96,t*-1);
% end

% tank='SAM-171027';
% block=1;
% %getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% %getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);


% tank='SAM-171103';
% block=1; %No spikes need to check scaling
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171103'], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171103'], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% tank='SAM-171103';
% block=3;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171103'], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171103'], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 

% tank='SAM-171107';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171107'], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171107'], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171107'], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171107'], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% 
% tank='SAM-171108';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171108'], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171108'], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171108'], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\SLY-171108'], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% 
% 
% tank='SAM-171116';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-171122';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% 
% tank='SAM-171205';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-171207';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-171219';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-171220';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-180102';
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-180107';
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);




% tank='SAM-180124'; Only Block-3
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
%%
% tank='SAM-180129';
% block=1; %need to rename tank files to Block-1 instead of Block1
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);

% tank='SAM-180131'; Only XPZ5 files not XPZ2
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);

% tank='SAM-180207';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% 
% 
% tank='SAM-180212';
% block=1;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=2;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);
% block=3;
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz2', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_AL']);
% getting_tank_data_binary(['D:\SpikeSortingPipeline\Tanks\' tank], block, 'xpz5', 96, 0, 0, 0, ['H:\ToSort\' tank '_b' num2str(block) '_ML']);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_AL.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_AL\'], 96);
% matToKiloSort(['H:\ToSort\' tank '_b' num2str(block) '_ML.dat'], ['H:\Sorted\' tank '_b' num2str(block) '_ML\'], 96);



% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180207', 1, 'xpz2', 96, 0, 0, 0, 'H:\SAM_180207_b1_AL');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180207', 1, 'xpz5', 96, 0, 0, 0, 'H:\SAM_180207_b1_ML');
% 
%  matToKiloSort('H:\SAM_180207_b1_AL.dat', 'H:\SAM_180207b1_AL\', 96);
%  matToKiloSort('H:\SAM_180207_b1_ML.dat', 'H:\SAM_180207b1_ML\', 96);

% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 2, 'xpz2', 96, 0, 0, 0, 'H:\SAM_180114_b2_AL');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 2, 'xpz5', 96, 0, 0, 0, 'H:\SAM_180114_b2_ML');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz2', 96, 0, 0, 0, 'H:\SAM_180114_b3_AL');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz5', 96, 0, 0, 0, 'H:\SAM_180114_b3_ML');
% 
% matToKiloSort('H:\SAM_180114_b2_AL.dat', 'H:\SAM_180114b2_AL\', 96);%STRF
% matToKiloSort('H:\SAM_180114_b2_ML.dat', 'H:\SAM_180114b2_ML\', 96);
% matToKiloSort('H:\SAM_180114_b3_AL.dat', 'H:\SAM_180114b3_AL\', 96);
% matToKiloSort('H:\SAM_180114_b3_ML.dat', 'H:\SAM_180114b3_ML\', 96);
% 
% running_strf

% 
%getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 2, 'xpz2', 96, 0, 0, 0, 'H:\SAM_180114_b2_AL');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 2, 'xpz5', 96, 0, 0, 0, 'H:\SAM_180114_b2_ML');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz2', 96, 0, 0, 0, 'H:\SAM_180114_b3_AL');
% getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz5', 96, 0, 0, 0, 'H:\SAM_180114_b3_ML');
% 
% matToKiloSort('H:\SAM_180114_b2_AL.dat', 'H:\SAM_180114b2_AL\', 96);
% matToKiloSort('H:\SAM_180114_b2_ML.dat', 'H:\SAM_180114b2_ML\', 96);
% matToKiloSort('H:\SAM_180114_b3_AL.dat', 'H:\SAM_180114b3_AL\', 96);
% matToKiloSort('H:\SAM_180114_b3_ML.dat', 'H:\SAM_180114b3_ML\', 96);
% toc

%getting_tank_data_binary('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz5', 96, 0, 0, 0, 'H:\SAM_180114_b3_ML');
%matToKiloSort('H:\SAM_180114_b3_ML.dat', 'H:\SAM_180114b3_ML\', 96);




% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180114', 2, 'xpz2', 96, 0, 0, 0, 'H:\SAM-180114_AL');
% clear all
% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180114', 2, 'xpz5', 96, 0, 0, 0, 'H:\SAM-180114_ML');
% clear all
% matToKiloSort('H:\SAM-180114_ML\SAM-180114_b2_ML.dat', 'H:\Test_180114b2_ML\', 96);
% matToKiloSort('H:\SAM-180114_AL\SAM-180114_b2_AL.dat', 'H:\Test_180114b2_AL\', 96);
% 
% 
% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz2', 96, 0, 0, 0, 'H:\SAM-180114_AL');
% clear all
% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180114', 3, 'xpz5', 96, 0, 0, 0, 'H:\SAM-180114_ML');
% clear all
% matToKiloSort('H:\SAM-180114_ML\SAM-180114_b3_ML.dat', 'H:\Test_180102b3_ML\', 96);
% matToKiloSort('H:\SAM-180114_AL\SAM-180114_b3_AL.dat', 'H:\Test_180102b3_AL\', 96);
% 
% 
% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-180102', 1, 'xpz2', 96, 0, 0, 0, 'H:\Test_180102_AL');
% clear all
% getting_data_tank('D:\SpikeSortingPipeline\Tanks\SAM-180102', 1, 'xpz5', 96, 0, 0, 0, 'H:\Test_180102_ML');
% clear all
% matToKiloSort('H:\Test_180102_ML\SAM-180102_b1_ML.dat', 'H:\Test_180102b1_ML\', 96);
% matToKiloSort('H:\Test_180102_AL\SAM-180102_b1_AL.dat', 'H:\Test_180102b1_AL\', 96);
% 





% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-180107\Block-2';
%    fpath='h:\SAM-180107_Block-2\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-180102\Block-1';
%    fpath='h:\SAM-180102_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-180102\Block-2';
%    fpath='h:\SAM-180102_Block-2\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);


% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171205\Block-1';
%    fpath='h:\SAM-171205_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171205\Block-2';
%    fpath='h:\SAM-171205_Block-2\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);

% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171130\Block-1';
%    fpath='h:\SAM-171130_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171130\Block-2';
%    fpath='h:\SAM-171130_Block-2\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
%    
%    
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171130\Block-3';
%    fpath='h:\SAM-171130_Block-3\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 






% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171122\Block-1';
%    fpath='h:\SAM-171122_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171116\Block-1';
%    fpath='h:\SAM-171116_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);

% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171108\Block-1';
%    fpath='h:\SAM-171108_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171108\Block-1';
%    fpath='h:\SAM-171108_Block-2\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);


% fbinary='D:\SpikeSortingPipeline\Tanks\Sly-171107\Block-1';
%    fpath='h:\SAM-171117_Block-1\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Sly-171107\Block-2';
%    fpath='h:\SAM-171117_Block-2\KiloSort';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
% 
%    
%     fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-1';
%   fpath='h:\SAM-171017_Block-1\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);

% %Getting binary
% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-171015',1,'xpz2',96,1,0,0,'D:\SpikeSortingPipeline\ToSort');
% %ML
% getting_tank_data('D:\SpikeSortingPipeline\Tanks\SAM-171015',1,'xpz5',96,1,0,0,'D:\SpikeSortingPipeline\ToSort\ML');
% 
% 
% fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171013\Block-6';
%   fpath='h:\SAM-171013_Block-6\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);

% 
%  fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171027\Block-1';
%   fpath='h:\SAM-171027_Block-1\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171027\Block-2';
%   fpath='h:\SAM-171027_Block-2\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);


% 

%  fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171018\Block-1';
%   fpath='h:\SAM-171018_v2_Block-1\KiloSort';
%   matToKiloSort_v2(fbinary,fpath,num_channels);
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171018\Block-2';
%   fpath='h:\SAM-171018_v2_Block-2\KiloSort';
%   matToKiloSort_v2(fbinary,fpath,num_channels);
%   
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171018\Block-3';
%   fpath='h:\SAM-171018_v2_Block-3\KiloSort';
%   matToKiloSort_v2(fbinary,fpath,num_channels);
%   
%   
%  fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171018\Block-4';
%   fpath='h:\SAM-171018_v2_Block-4\KiloSort';
%   matToKiloSort_v2(fbinary,fpath,num_channels);
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171018\Block-5';
%   fpath='h:\SAM-171018_v2_Block-5\KiloSort';
%   matToKiloSort_v2(fbinary,fpath,num_channels);
%   
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171018\Block-6';
%   fpath='h:\SAM-171018_v2_Block-6\KiloSort';
%   matToKiloSort_v2(fbinary,fpath,num_channels);






%  fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-1';
%   fpath='h:\SAM-171017_Block-1\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-2';
%   fpath='h:\SAM-171017_Block-2\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-3';
%   fpath='h:\SAM-171017_Block-3\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%   
%  fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-4';
%   fpath='h:\SAM-171017_Block-4\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-5';
%   fpath='h:\SAM-171017_Block-5\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171017\Block-6';
%   fpath='h:\SAM-171017_Block-6\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);




%  fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171015\Block-1';
%   fpath='h:\SAM-171015_Block-1\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171015\Block-2';
%   fpath='h:\SAM-171015_Block-2\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%   
%    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171015\Block-3';
%   fpath='h:\SAM-171015_Block-3\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
















%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171013\Block-6';
%   fpath='h:\SAM-171013_Block-6\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
% %%
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171013\Block-5';
%   fpath='h:\SAM-171013_Block-5\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   














% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-171012\Block-1';
%   fpath='h:\SAM-171012_Block-1\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171012\Block-2';
%   fpath='h:\SAM-171012_Block-2\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171012\Block-3';
%   fpath='h:\SAM-171012_Block-3\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171012\Block-4';
%   fpath='h:\SAM-171012_Block-4\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
  
  

%   getting_tank_data('d:\SpikeSortingPipeline\Tanks\SAM-171011\', 6, 'xpz2', chan_num, 1, 1, 0, ...
%                 ['H:\test\AL']);
%             disp('Converting ML data... ');
%             getting_tank_data('d:\SpikeSortingPipeline\Tanks\SAM-171011\', 6, 'xpz5', chan_num, 1, 1, 0, ...
%                 ['H:\test\ML']);
%             
%             %%
%              fbinary='H:\test\al\SAM-171011.dat';
%    fpath='H:\test\KiloSort_6';
%    matToKiloSort_v2(fbinary,fpath,96);
%  
%  %%
%    fbinary='H:\test\al';
%    fpath='H:\test\KiloSort_6';
%    matToKiloSort_v3(fbinary,fpath,num_channels);
 
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171011\Block-6';
%   fpath='h:\SAM-171011_Block-6\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels); 
%  
% %    fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171004\Block-1';
% %   fpath='h:\SAM-171004_Block-1\KiloSort_6';
% %   matToKiloSort_v3(fbinary,fpath,num_channels);
% %  
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171004\Block-2';
%   fpath='h:\SAM-171004_Block-2\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
  %%
%     fbinary='d:\SpikeSortingPipeline\Tanks\SAM-171004\Block-3';
%   fpath='h:\SAM-171004_Block-3\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%   
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-170929\Block-3';
%   fpath='h:\SAM-170929_Block-3\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
% 
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-170929\Block-2';
%   fpath='h:\SAM-170929_Block-2\KiloSort_6';
%   matToKiloSort_v3(fbinary,fpath,num_channels);

 %%
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-170929\Block-2';
%   fpath='h:\SAM-170929_Block-2\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%  
%   fbinary='d:\SpikeSortingPipeline\Tanks\SAM-170929\Block-3';
%   fpath='h:\SAM-170929_Block-3\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
 
 
%   fbinary='f:\SpikeSortingPipeline\Tanks\SAM-170928\Block-2';
%   fpath='h:\SAM-170928_Block-2\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%  
%   fbinary='f:\SpikeSortingPipeline\Tanks\SAM-170928\Block-3';
%   fpath='h:\SAM-170928_Block-3\KiloSort';
%   matToKiloSort_v3(fbinary,fpath,num_channels);
%  
  
% fbinary='f:\SpikeSortingPipeline\Tanks\SAM-170919\Block-1';
% fpath='h:\SAM-170919_Block-3\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
%  
% fbinary='f:\SpikeSortingPipeline\Tanks\SAM-170919\Block-2';
% fpath='h:\SAM-170919_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
 
%  
%  fbinary='f:\SpikeSortingPipeline\Tanks\SAM-170913\Block-3';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170913_Block-3\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
%  
% fbinary='f:\SpikeSortingPipeline\Tanks\SAM-170913\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170913_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
 
 
 
 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170911\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170911_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
 
 
 
 
 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170824\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170824_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170824\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170824_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170824\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170824_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 





% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170804\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170804_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
%  
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170804\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170804_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
%  
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170804\Block-3';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170804_Block-3\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
%  
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170802\Texture-170802-111618';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170802_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul27_17_192ch_sr25k\Block-1';
% fpath='f:\SpikeSortingPipeline\Tanks\Jul27_17_192ch_sr25k_Block-1\KiloSort';
% matToKiloSort_v4(fbinary,fpath,num_channels);

% fbinary='D:\SpikeSortingPipeline\Tanks\Jul26_17_192ch_sr25k\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul26_17_192ch_sr25k_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);


% %Later
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul25_17_192ch_sr25k\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul25_17_192ch_sr25k_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul12_17_192ch_sr25k\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul12_17_192ch_sr25k_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul13b_17_192ch_sr25k\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul13b_17_192ch_sr25k_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

%%%STRF

% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170802\Texture-170802-134744';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170802_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
%  
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul27_17_192ch_sr25k\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul27_17_192ch_sr25k_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul26_17_192ch_sr25k\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul26_17_192ch_sr25k_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul25_17_192ch_sr25k\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul25_17_192ch_sr25k_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul12_17_192ch_sr25k\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul12_17_192ch_sr25k_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\Jul13b_17_192ch_sr25k\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\Jul13b_17_192ch_sr25k_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

 

 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170817\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170817_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170817\Block-3';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170817_Block-3\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170815\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170815_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170815\Block-3';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170815_Block-3\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);


% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170811\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170811_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170811\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170811_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170809\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170809_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170809\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170809_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170807\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170807_Block-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170807\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170807_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

%need yo add this ones
% fbinary='F:\SAM-170818\Block-1';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170818_Bloclck-1\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);

% fbinary='F:\SAM-170818\Block-2';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170818_Block-2\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);
% 
% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170815\Block-4';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170815_Block-4\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels);


% fbinary='D:\SpikeSortingPipeline\Tanks\SAM-170817\Block-4';
% fpath='F:\SpikeSortingPipeline\Sorted\SAM-170817_Block-4\KiloSort';
% matToKiloSort_v3(fbinary,fpath,num_channels)