@echo off
IF "%~1" == "" GOTO USAGE
IF NOT EXIST "%~1" GOTO FNF

set dir=%~d1%~p1
set sfv=%dir%%~n1.sfv
IF EXIST "%sfv%" GOTO EXISTS

@echo on
fsum -d"%dir%\" -crc32 -jnc -js "%~1" > "%sfv%"
@echo off

GOTO END

:USAGE
ECHO USAGE: %0 [file]
REM ~ pause
GOTO END

:FNF
ECHO FILE NOT FOUND: %~1
REM ~ pause
GOTO END

:EXISTS
ECHO FILE EXISTS: %sfv%
REM ~ pause
GOTO END

:END
REM ~ pause
