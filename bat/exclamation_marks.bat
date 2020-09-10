@echo off
setlocal
setlocal EnableDelayedExpansion

SET "args=df^!^!^!"
SET "args=df^!^!^!"
echo exclamation: !args!
REM ~ SET args=%args:!=^^!%
REM ~ echo exclamation: %args%
REM ~ FOR %%A IN (%*) DO (
FOR %%A IN (a b c d) DO (
    REM ~ SET args=%args% %%A & SET n=1
    REM ~ IF "!n!"=="1" SET args=!args! %%A & SET n=1
    echo exclamation: !args!
)
echo %args%
echo !args!

REM ~ SET exe=C:\PROGRA~1\AVIDEM~1.5\AVIDEM~1.EXE
REM ~ SET args="c:\download\flv\p\iamivanxxx\FIRE^^^!^^^!^^^!.flv" --quit
REM ~ start /min /low /wait %exe% %args%
