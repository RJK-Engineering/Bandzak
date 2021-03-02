@echo off
setlocal

echo Name:         %~n0
echo Extension:    %~x0
echo Drive letter: %~d0
echo Dirs:         %~p0
echo Dir:          %~dp0

for /f "delims=" %%P in ("%~dp0.") do set name=%%~nP
echo Dir name:     %name%

for /f "delims=" %%P in ("%~dp0..") do set parent=%%~dpfP
echo Parent:       %parent%
for /f "delims=" %%P in ("%parent%\..") do set parent=%%~dpfP
echo Parent:       %parent%
for /f "delims=" %%P in ("%parent%\..") do set parent=%%~dpfP
echo Parent:       %parent%
