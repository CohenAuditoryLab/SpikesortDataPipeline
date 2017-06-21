@echo off
call setPaths.bat
cd %dest%
dir
set /p fname=Dataset to Visualize: 
cd %fname%\Kilosort
call activate phy
phy template-gui params.py