:: old snippit that im not using anymore, but this code might be useful for something else one day

:: SHA-1 check
:: https://superuser.com/questions/245775/is-there-a-built-in-checksum-utility-on-windows-7/898377#898377
:: https://www.nextofwindows.com/5-ways-to-generate-and-verify-md5-sha-checksum-of-any-file-in-windows-10
:: First check for the old file. If it doesn't exist, then skip this section.
:: check SHA1 of the old file (will be named ccleaner or defraggler)
set _sha_old=none
REM certutil -hashfile %1>shacheck
certutil -hashfile portable>shacheck
for /F "delims=" %%a in ('findstr /V "SHA1 CertUtil:" shacheck') do set "_sha_old=%%a"
:: check SHA1 of the new file (will be named portable or standard)
REM certutil -hashfile %2>shacheck
certutil -hashfile portable.1>shacheck
for /F "delims=" %%a in ('findstr /V "SHA1 CertUtil:" shacheck') do set "_sha_new=%%a"
:: cleanup
del shacheck
:: compare
if %_sha_old%==%_sha_new% (
    echo No update found
    REM CLEANUP HERE
    exit /b 1
) else if NOT %_sha_old%==%_sha_new% (
    echo update found.
    echo downloading update . . .
)