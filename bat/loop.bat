@echo off

SET errorcheck=
SET timeout=10
SET randomtimeout=
SET randomtimeoutdivider=100
SET cmd=
SET args=

:getopt
IF "%~1"=="" GOTO endgetopt
IF "%~1"=="/e" SET errorcheck=1& GOTO nextopt
IF "%~1"=="/t" SET timeout=%2& SHIFT& GOTO nextopt
IF "%~1"=="/r" SET randomtimeout=1& GOTO nextopt
IF not DEFINED cmd (
    SET cmd=%1
    IF "%~x1"==".bat" SET cmd=CALL %1
) ELSE IF not DEFINED args (
    SET args=%1
) ELSE (
    SET args=%args% %1
)
:nextopt
SHIFT & GOTO getopt
:endgetopt

IF "%timeout%"=="0" SET timeout=

:GO
%cmd% %args%
IF DEFINED errorcheck IF %errorlevel% EQU 0 goto END
IF DEFINED timeout TIMEOUT %timeout%
IF DEFINED randomtimeout (
    TIMEOUT %seconds%
    set /a seconds=%RANDOM%/%randomtimeoutdivider%
)
goto GO

:END
