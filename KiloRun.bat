set /p file= File Name: 
matlab -nodisplay -nosplash -nodesktop -r TDTtoKiloSort(%file%)
cd C:\work\datafiles\spikes\%file%
call activate phy
phy template-gui params.py