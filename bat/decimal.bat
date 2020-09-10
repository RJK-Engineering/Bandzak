@echo off

rem Determine if a var contains a decimal number.
rem The numbers may not contain leading zeros because in expression for "set /a":
rem Numeric constants are either decimal (17), hexadecimal (0x11), or octal (021).

set var=%1
set /a "num=%var%+0" 2>NUL
echo "%var%" == "%num%"
if "%var%" == "%num%" (echo decimal number) else (echo not a decimal number)
