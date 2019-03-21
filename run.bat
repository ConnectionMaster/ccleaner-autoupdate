@echo off
cd /d "%~dp0"

if %1==ccleaner goto type
if %1==defraggler goto type
exit /b 1
:type
if %2==portable goto main
if %2==standard goto main
exit /b 1

:main
:: UPDATE (and install)
call update.bat %1 %2

:: RUN
if %2==portable (
    if %PROCESSOR_ARCHITECTURE%==x86 start %1\%1.exe /auto
	if %PROCESSOR_ARCHITECTURE%==AMD64 start %1\%164.exe /auto
)
if %2==standard (
    if %PROCESSOR_ARCHITECTURE%==x86 start %programfiles%\%1\%1.exe /auto
	if %PROCESSOR_ARCHITECTURE%==AMD64 start %programfiles%\%1\%164.exe /auto
)
