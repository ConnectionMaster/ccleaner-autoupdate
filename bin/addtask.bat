@echo off
cd /d "%~dp0"
cd ..
:: http://superuser.com/questions/243605/how-do-i-specify-run-with-highest-privileges-in-schtasks
setlocal
set runlevel=

REM Get OS version from registry
for /f "tokens=2*" %%i in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentVersion"') do set os_ver=%%j

REM Set run level (for Vista or later - version 6)
if /i "%os_ver:~,1%" GEQ "6" set runlevel=/rl HIGHEST

REM Execute SchTasks.exe
SchTasks /Create /SC MONTHLY /D 1 /TN "CCleaner Update" /TR "'%cd%\update.bat'" /ST 14:00 /RU SYSTEM %runlevel%
REM SchTasks /Create /SC MONTHLY /D 1 /TN "CCleaner Update" /TR "'%cd%\update.bat'" /ST 14:00 %runlevel%
REM echo "%cd%\update.bat"
pause