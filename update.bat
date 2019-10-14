@echo off
cd /d "%~dp0"
:: ==================================================
:: Check Arguments
:: ==================================================
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
:: if the arguments were wrong, exit the batch script with errorcode 1
:: /b is needed otherwise it will exit cmd

:main
:: ==================================================
:: Check Network Connection
:: ==================================================
set NETWORK_AVAILABLE=yes
ipconfig /all | find /i "Subnet Mask" >NUL 2>&1
if /i not %ERRORLEVEL%==0 (
    echo No network connection found. Skipping update . . .
    exit /b 1
)

:: ==================================================
:: Download Link From Server
:: ==================================================
:: links you could use for the download
:: http://www.piriform.com/ccleaner/download/slim/downloadfile which also redirects to https://www.ccleaner.com/go/get_ccslim (replace slim with standard, portable, etc...)
:: https://www.ccleaner.com/ccleaner/download/portable
::first we download the header from the standard download site which has the redirect url
REM bin\wget --content-disposition -N -S https://www.ccleaner.com/go/get_ccportable
if %1==defraggler (
    bin\wget --content-disposition --server-response -O %2 https://www.ccleaner.com/%1/download/%2/downloadfile
) else if %1==ccleaner (
    bin\wget --content-disposition --server-response -O %2 https://www.ccleaner.com/%1/download/%2
)

:: ==================================================
:: Link Extraction
:: ==================================================
::now we look for the redirect url in the header file we downloaded
::http://stackoverflow.com/questions/22198458/find-text-in-file-and-set-it-as-a-variable-batch-file
for /F "delims=" %%a in ('findstr /I "data-download-url" %2') do set "new_link=%%a"
:: cleanup
del %2

:: Split String https://www.dostips.com/DtTipsStringManipulation.php#Snippets.SplitString
for /f "tokens=1,2,3,4 delims==" %%a in ("%new_link%") do set new_link=%%d

:: Remove "data-timeout" from the string https://www.dostips.com/DtTipsStringManipulation.php#Snippets.Remove
set "new_link=%new_link:data-timeout=%"

:: Remove spaces https://www.dostips.com/DtTipsStringManipulation.php#Snippets.RemoveSpaces
set new_link=%new_link: =%

:: Trim quotes https://www.dostips.com/DtTipsStringManipulation.php#Snippets.TrimQuotes
for /f "useback tokens=*" %%a in ('%new_link%') do set new_link=%%~a

set old_link=none
set /p old_link=<%1%2.txt

:: compare
if %old_link%==%new_link% (
    echo No update found.
    REM CLEANUP HERE
    exit /b 1
) else if NOT %old_link%==%new_link% (
    echo update found.
    echo downloading update . . .
    echo %new_link%>%1%2.txt
    bin\wget %new_link%
)

:: ==================================================
:: Install
:: ==================================================
if %1=="defraggler" (
    if %2=="portable" (
        goto df_portable_inst
    ) else if %2=="standard" (
        goto df_std_inst
    )
)

:: PORTABLE
for %%f in ("%~dp0ccsetup*.zip") do (
    echo Installing . . .
    ::  start extracting using 7zip overwriting all files
    REM bin\7z x -o"%installdir%" -aoa "%%~ff"
    bin\7za x -o"%1" -y "%%~ff"
    echo Finished
    del %%~ff
    exit /b 1
)

:df_portable_inst
:: PORTABLE DEFRAGGLER
for %%f in ("%~dp0dfsetup*.exe") do (
    echo Installing . . .
    ::  start extracting using 7zip overwriting all files
    REM bin\7z x -o"%installdir%" -aoa "%%~ff"
    bin\7z x -o"%1" -y "%%~ff"
    del "%1\uninst.exe"
    rd /s /q "%1\$_117_"
    rd /s /q "%1\$_118_"
    rd /s /q "%1\$PLUGINSDIR"
    :: remove the old .dll files just in case they've been updated
    del "%1\DefragglerShell.dll"
    del "%1\DefragglerShell64.dll"  
    ren "%1\DefragglerShell.dll.new" "DefragglerShell.dll"
    ren "%1\DefragglerShell64.dll.new" "DefragglerShell64.dll"
    echo #PORTABLE# >./defraggler/portable.dat
    echo Finished
    del %%~ff
    exit /b 1
)

:: STANDARD INSTALLATION
for %%f in ("%~dp0ccsetup*.exe") do (
	echo Installing . . .
	:: execute the setup in silent mode
	REM [DEBUG] comment this for debugging
	%%~ff /S
	echo Finished
    del %%~ff
    exit /b 1
)

:df_std_inst
::defraggler standard WIP
for %%f in ("%~dp0dfsetup*.exe") do (
	echo Installing . . .
	:: execute the setup in silent mode
	REM [DEBUG] comment this for debugging
	%%~ff /S
	echo Finished
    del %%~ff
    exit /b 1
)
