@echo off

REM get date string
for /f "tokens=1-7 delims=-/, " %%d in ("%date%") do set now=%%g%%f%%e
echo %now%

REM this file's date and time
for %%F in (%0) do SET file_date=%%~tF
for /f "tokens=1-5 delims=-: " %%d in ("%file_date%") do set file_date_str=%%f%%e%%d%%g%%h
echo %file_date_str%
