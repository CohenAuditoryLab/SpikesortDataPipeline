@echo off
call setPaths.bat
cd %dest%
dir
set /p fname=Dataset to Visualize: 
cd %fname%/Kilosort
echo Activating Phy. Please wait...
call activate phy
phy template-gui params.py
