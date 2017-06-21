@echo off
call setPaths.bat
cd %origin%
pause
for /D %%f in (*) do (
  mkdir %dest%\%%f
  cd %dest%\%%f
  mkdir RawData KiloSort WaveClus Metrics
  move %origin%\%%f %dest%\%%f\RawData
  :: Register TDT
  :: Create MATLAB file
  matlab -nodisplay -nosplash -nodesktop -r TDTtoKiloSort(%dest%\%%f\RawData\%%f.mat,%dest%\%%f\KiloSort)
  matlab -nodisplay -nosplash -nodesktop -r mat2waveclus(%dest%\%%f\RawData\%%f.mat,%dest%\%%f\WaveClus)
  matlab -nodisplay -nosplash -nodesktop -r sorting_metrics(%dest%\%%f\KiloSort,kilo,%dest%\%%f\Metrics\KiloSort)
  matlab -nodisplay -nosplash -nodesktop -r sorting_metrics(%dest%\%%f\WaveClus\clusters_%%f,wave,%dest%\%%f\Metrics\WaveClus)
)
