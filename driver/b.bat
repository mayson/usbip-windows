rem batch file to build complete drivers: output will be put in output directory

set OCD=%CD%

set TYPE=chk

IF "%BASEDIR%"=="" (
set BASEDIR=\WinDDK\7600.16385.1
CALL \WinDDK\7600.16385.1\bin\setenv.bat \WinDDK\7600.16385.1 %TYPE%     WLH
cd /d %OCD%
)

cmd /C "set DDKBUILDENV=&& %BASEDIR%\bin\setenv.bat %BASEDIR% %TYPE% x64 WLH && cd /d %OCD% && build"

rem copy files to output folder
mkdir output
copy USBIPEnum.inf output
copy obj%TYPE%_wlh_amd64\amd64\USBIPEnum.sys output\USBIPEnum_x64.sys

rem sign files and create catalog file
signtool sign /v /ac thawte.cer /td sha256 /fd sha256 /tr http://timestamp.digicert.com /a output\USBIPEnum_x64.sys

inf2cat /driver:output /os:Vista_X64,Server2008_X64,7_X64,Server2008R2_X64 /VERBOSE

signtool sign /v /ac thawte.cer /td sha256 /fd sha256 /tr http://timestamp.digicert.com /a output\USBIPEnum.cat

