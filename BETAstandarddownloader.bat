@echo off
cd /d "%~dp0"
:: usage: update.bat [ccleaner | defraggler] [portable | standard]
:: you can choose to download either ccleaner or defraggler 
:: selecting portable or standard will determine the type of setup
if %1==ccleaner goto type
if %1==defraggler goto type
exit /b 1
:type
if %2==portable goto main
if %2==standard goto main
exit /b 1
:: of the arguments were wrong, exit the batch script with errorcode 1

:main
:: check network connection
set NETWORK_AVAILABLE=yes
ipconfig /all | find /i "Subnet Mask" >NUL 2>&1
if /i not %ERRORLEVEL%==0 set NETWORK_AVAILABLE=no
:: maybe we exit here if there is no network connection?

:: links you could use for the download
:: http://www.piriform.com/ccleaner/download/slim/downloadfile which also redirects to https://www.ccleaner.com/go/get_ccslim (replace slim with standard, portable, etc...)
:: https://www.ccleaner.com/ccleaner/download/portable
::first we download the header from the standard download site which has the redirect url
REM bin\wget --content-disposition -N -S https://www.ccleaner.com/ccleaner/download/portable
REM bin\wget --content-disposition -N -S https://www.ccleaner.com/go/get_ccportable

pause

:: SHA-1 check
:: https://superuser.com/questions/245775/is-there-a-built-in-checksum-utility-on-windows-7/898377#898377
:: https://www.nextofwindows.com/5-ways-to-generate-and-verify-md5-sha-checksum-of-any-file-in-windows-10
:: First check for the old file. If it doesn't exist, then skip this section.
:: check SHA1 of the old file
certutil -hashfile portable.1>shacheck
for /F "delims=" %%a in ('findstr /V "SHA1 CertUtil:" shacheck') do set "_sha_old=%%a"
:: check SHA1 of the new file
certutil -hashfile get_ccportable>shacheck
for /F "delims=" %%a in ('findstr /V "SHA1 CertUtil:" shacheck') do set "_sha_new=%%a"
:: cleanup
del shacheck
:: compare
if %_sha_old%==%_sha_new% (
    echo no update found
    REM CLEANUP HERE
    REM EXIT HERE? or go to the next step?
) else if NOT %_sha_old%==%_sha_new% (
    echo update found . . .
    echo downloading update . . .
)
pause

::now we look for the redirect url in the header file we downloaded
::http://stackoverflow.com/questions/22198458/find-text-in-file-and-set-it-as-a-variable-batch-file
:: if you download from https://www.ccleaner.com/ccleaner/download/portable
for /F "delims=" %%a in ('findstr /I "data-download-url" portable.1') do set "link=%%a"

:: Split String https://www.dostips.com/DtTipsStringManipulation.php#Snippets.SplitString
for /f "tokens=1,2,3,4 delims==" %%a in ("%link%") do set link=%%d

:: Remove "data-timeout" from the string https://www.dostips.com/DtTipsStringManipulation.php#Snippets.Remove
set "link=%link:data-timeout=%"

:: Remove spaces https://www.dostips.com/DtTipsStringManipulation.php#Snippets.RemoveSpaces
set link=%link: =%

:: Trim quotes https://www.dostips.com/DtTipsStringManipulation.php#Snippets.TrimQuotes
for /f "useback tokens=*" %%a in ('%link%') do set link=%%~a

echo %link%
pause

echo stage 2, downloading the standard installer
REM bin\wget -nc %link:~65,43%
echo.
:: remove indentations (from the remove spaces section of this link)
:: http://www.dostips.com/DtTipsStringManipulation.php
set "link=%link:	=%"
REM echo."%link%"
echo %link:~63,43%
pause
REM [DEBUG] echo %link:~65,43%
REM [DEBUG] pause
::cleanup the header file
REM del standard

rem installing would be the same as the slim installer
rem ccsetupxxx.exe /S

:: PROCESSING/INSTALLING/EXTRACTING

:: PORTABLE
for %%f in ("%~dp0ccsetup*.zip") do (
    echo Installing . . .
    ::  start extracting using 7zip overwriting all files
    REM bin\7z x  -o"%installdir%" -aoa "%%~ff"
    REM bin\7z x -o"%installdir%" -y "%%~ff"
    echo Finished
)

:: STANDARD INSTALLATION
for %%f in ("%~dp0ccsetup*.exe") do (
		echo Installing . . .
		:: execute the setup in silent mode
		REM [DEBUG] comment this for debugging
		%%~ff /S
		echo Finished
	)
)