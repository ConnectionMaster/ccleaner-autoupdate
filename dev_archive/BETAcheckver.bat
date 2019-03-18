@echo off
cd /d "%~dp0"
REM HKCU\SOFTWARE\Piriform\CCleaner\NewVersion
for /f "tokens=3*" %%i IN ('reg query "HKCU\SOFTWARE\Piriform\CCleaner" /v NewVersion ^| find "NewVersion"') DO set CC_VER=%%i %%j
echo %CC_VER%
REM echo %CC_VER:~0,1%
REM echo %CC_VER:~2,2%
set verver=%CC_VER:~0,1%%CC_VER:~2,2%
echo %verver%
pause
bin\wget
pause