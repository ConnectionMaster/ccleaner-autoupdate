@echo off
cd /d "%~dp0"
:: http://superuser.com/questions/243605/how-do-i-specify-run-with-highest-privileges-in-schtasks
setlocal
REM set runlevel=

:: Get OS version from registry
for /f "tokens=2*" %%i in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentVersion"') do set os_ver=%%j

:: Set run level (for Vista or later - version 6)
REM if /i "%os_ver:~,1%" GEQ "6" set runlevel=/rl HIGHEST

REM Execute SchTasks.exe
REM SchTasks /Create /SC MONTHLY /D 1 /TN "CCleaner Update" /TR "'%cd%\update.bat'" /ST 14:00 /RU SYSTEM %runlevel%
:: This one for XP
REM SchTasks /Create /SC DAILY /MO 30 /TN "CCleaner Update test" /TR "'%cd%\update.bat'" /ST 14:00 /RU SYSTEM %runlevel%
REM SchTasks /Create /SC MONTHLY /D 1 /TN "CCleaner Update" /TR "'%cd%\update.bat'" /ST 14:00 %runlevel%
REM echo "%cd%\update.bat"


if /i "%os_ver:~,1%" GEQ "6" (
	REM echo win 6+ detected
	:: This one for Vista or later
	schtasks /create /xml "%cd%\ccleanerupdate.xml" /tn "CCleaner Update"
) else (
	REM echo winxp detected
	:: This one for XP
	cd ..
	SchTasks /Create /SC DAILY /MO 30 /TN "CCleaner Update" /TR "'%cd%\update.bat'" /ST 14:00 /RU SYSTEM
)
pause