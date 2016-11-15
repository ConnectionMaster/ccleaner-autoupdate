REM this script has a snippet to download the standard installer for when the slim installer is not available
@echo off
cd /d "%~dp0"
::first we download the header from the standard download site which has the redirect url
bin\wget --content-disposition http://www.piriform.com/ccleaner/download/standard

::now we look for the redirect url in the header file we downloaded
::http://stackoverflow.com/questions/22198458/find-text-in-file-and-set-it-as-a-variable-batch-file
for /F "delims=" %%a in ('findstr /I "data-download-url" standard') do set "link=%%a"

::http://www.dostips.com/DtTipsStringManipulation.php
::skip the first 31 characters and continue for 43 characters to get the download url

echo stage 2, downloading the standard installer
bin\wget -nc %link:~65,43%
REM [DEBUG] echo %link:~65,43%
REM [DEBUG] pause
::cleanup the header file
del standard

rem installing would be the same as the slim installer
rem ccsetupxxx.exe /S