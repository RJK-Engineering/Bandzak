@ECHO OFF
SETLOCAL

SET errors=0

rem EnableDelayedExpansion needed to get errorlevel in for loop,
rem but then ! will be interpreted in filenames...
rem SETLOCAL EnableDelayedExpansion

FOR /F "tokens=*" %%F IN (%filelist%) DO (
        %cmd% %args%
        rem only works with EnableDelayedExpansion
        IF !errorlevel! GTR 0 SET /a errors=!errors!+1
    )
)

IF %errors% GTR 0 (
    IF %errors% GTR 1 (ECHO %errors% errors) ELSE (ECHO 1 error)
)
