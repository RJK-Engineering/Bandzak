@echo off

rem First and second arg must not contain ampersand "&" because
rem surrounding quotes are removed which results in incorrect interpretation.
rem Switch /s must be specified before other args.
rem Example:
rem c:\>args2 "a b" "c d" /s /v 2 "e & f" "g & h"
rem Switch: 1.
rem Value: 2.
rem First: a b.
rem Second: c d.
rem Other: "e & f" "g & h".

rem setlocal: master environment is not affected
setlocal
rem clear vars, they are inherited from master environment
SET switch=
SET value=
SET firstarg=
SET secondarg=
SET otherargs=

:getopt
IF "%~1"=="" GOTO endgetopt
IF DEFINED otherargs SET otherargs=%otherargs% %1& GOTO nextopt
IF "%~1"=="/s" SET switch=1& GOTO nextopt
IF "%~1"=="/v" SET value=%2& SHIFT& GOTO nextopt
IF NOT DEFINED firstarg SET firstarg=%~1& GOTO nextopt
IF NOT DEFINED secondarg SET secondarg=%~1& GOTO nextopt
SET otherargs=%1
:nextopt
SHIFT & GOTO getopt
:endgetopt

ECHO Switch: %switch%.
ECHO Value: %value%.
ECHO First: %firstarg%.
ECHO Second: %secondarg%.
ECHO Other: %otherargs%.
