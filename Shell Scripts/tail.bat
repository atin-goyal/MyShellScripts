@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem tail.bat -d <lines> <file>
rem tail.bat -f <file>

rem ****** MAIN ****** 
IF "%1"=="-d" GOTO displayfile
IF "%1"=="-f" GOTO followfile

GOTO end

rem ************ 
rem Show Last n lines of file
rem ************ 

:displayfile
SET skiplines=%2
SET sourcefile=%3

rem *** Get the current line count of file ***
FOR /F "usebackq tokens=3,3 delims= " %%l IN (`find /c /v "" %sourcefile%`) DO (call SET find_lc=%%l)

rem *** Calculate the lines to skip
SET /A skiplines=%find_lc%-!skiplines!

rem *** Display to screen line needed
more +%skiplines% %sourcefile%

GOTO end

rem ************ 
rem Show Last n lines of file & follow output
rem ************ 

:followfile
SET skiplines=0
SET findend_lc=0
SET sourcefile=%2

:followloop
rem *** Get the current line count of file ***
FOR /F "usebackq tokens=3,3 delims= " %%l IN (`find /c /v "" %sourcefile%`) DO (call SET find_lc=%%l)
FOR /F "usebackq tokens=3,3 delims= " %%l IN (`find /c /v "" %sourcefile%`) DO (call SET findend_lc=%%l)

rem *** Calculate the lines to skip
SET /A skiplines=%findend_lc%-%find_lc%
SET /A skiplines=%find_lc%-%skiplines%

rem *** Display to screen line when file updated
more +%skiplines% %sourcefile%

goto followloop

:end
