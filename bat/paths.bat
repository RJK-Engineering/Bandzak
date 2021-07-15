@echo off
setlocal

if not "%~1"=="" shift

echo Argument:     %%0      %0
echo Path:         %%~f0    %~f0
echo Path:         %%~dpnx0 %~dpnx0
echo Drive letter: %%~d0    %~d0
echo Dirs:         %%~p0    %~p0
echo Name:         %%~n0    %~n0
echo Extension:    %%~x0    %~x0
echo Parent:       %%~dp0   %~dp0
if "%~n0"=="" goto END

for /f "delims=" %%P in ("%~dp0.") do (set parent=%%~fP& set name=%%~nxP)
echo Parent:       %parent% %name%
if not defined name goto END

for /f "delims=" %%P in ("%~dp0..") do (set parent=%%~fP& set name=%%~nxP)
echo Parent:       %parent% %name%
if not defined name goto END

:PARENTS
for /f "delims=" %%P in ("%parent%\..") do (set parent=%%~fP& set name=%%~nxP)
echo Parent:       %parent% %name%
if not defined name goto END
goto PARENTS

:END

set var=C:\a\b\c\d.e
for /f "delims=" %%P in ("%var%") do set name=%%~nxP
echo Var: %var% %name%
