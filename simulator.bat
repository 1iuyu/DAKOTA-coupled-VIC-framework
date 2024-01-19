@echo off
REM Parameters and results filenames
set params=%1
set results=%2
REM Assuming Matlab .m files and any necessary data are in ./
REM from which Dakota is run.
matlab -batch "matlab_wrapper('%params%', '%results%') ; exit"
