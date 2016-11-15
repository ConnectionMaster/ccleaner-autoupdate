@echo off
::if you run this as administrator or with UAC disabled, you will not be prompted to run the installer, it will be automatic

::change working directory to the script location so that wget downloads to the script location (easier for cleanup)
cd /d "%~dp0"

:: first we search for existing ccsetup files to determine the last version this script installed
for %%f in ("%~dp0ccsetup*.exe") do (
	:: assume that this is the current version
	set cver=%%~nf
)
::if there are no ccsetup files, then assume that this script has never installed ccleaner
if not exist "%~dp0%cver%.exe" ( set cver=none )

REM [DEBUG]
echo current install is %cver%

::download the "slim" installer, which comes with no special promos or anything
::using the --no-clober switch, we ensure that we dont redownload the current version
echo Checking server for updates . . .
echo.
"%~dp0bin\wget" -nc --content-disposition http://www.piriform.com/ccleaner/download/slim/downloadfile

::if we get a 404 not found or unable to resolve host error, then either ccleaner slim is temporarily unavailable, or there is no network connection.
::we stop the script and exit with code 0x1 so that windows task scheduler can attempt to try again later
if %errorlevel%==1 exit 1
::if Piriform's website doesnt have a slim installer up for the latest version, then wget will download a 0KB file titled "downloadfile"
::so then delete this junk file then exit with 0x1 to try again later
if exist "%~dp0downloadfile" (
	echo CCleaner slim installer has not updated on the Piriform website yet.
	del "%~dp0downloadfile"
	REM [DEBUG] this is a debug pause
	REM pause
	exit 1
	)

::if we download a new setup file, delete all but the latest ccsetup file
::http://stackoverflow.com/questions/13367746/batch-file-that-keeps-the-7-latest-files-in-a-folder
for /f "skip=1 eol=: delims=" %%F in ('dir /b /o-d "%~dp0ccsetup*.exe"') do @del "%%F"

for %%f in ("%~dp0ccsetup*.exe") do (
	:: if the ccsetup file that we find is the same version as the previous one, then we skip the install
	if %%~nf==%cver% (
		echo CCleaner is already up to date [%%~nf]
	) else (
		echo A newer version of CCleaner was found [%cver% --^> %%~nf]
		echo Installing . . .
		:: execute the setup in silent mode
		REM [DEBUG] comment this for debugging
		%%~ff /S
		echo Finished
	)
)
REM echo.
pause