@echo off
setlocal
setlocal EnableDelayedExpansion

REM skip first 2 arguments

SET args=
REM ~ FOR %%A IN (%*) DO (
FOR %%A IN (a b c d e) DO (
    IF !n! GTR 1 SET args=!args! %%A
    SET /a n+=1
    REM ~ echo !n!
)
IF NOT "%args%"=="" echo %args%
echo !n!
