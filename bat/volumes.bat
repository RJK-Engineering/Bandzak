@echo off

echo list volume| diskpart

echo.
echo.
echo Only works when all fields are present
for /f "tokens=1-10" %%F in ('echo list volume^| diskpart') do (
    if "%%F"=="Volume" if "%%K"=="Partition" (
        echo Nr=%%G Ltr=%%H Label=%%I Fs=%%J Type=%%K Size=%%L%%M Status=%%N Info=%%O
    )
)

echo.
echo Get fields by position
set volume_last_nr=0
for /f "tokens=1,*" %%F in ('echo list volume^| diskpart') do (
    if "%%F"=="Volume" (
        for /f "tokens=1,*" %%H in ("%%G") do set volume_%%H=%%G
        set volume_last_nr=%%H
    )
)
echo Nr=%volume_1:~0,4%
echo Ltr=%volume_1:~6,1%
echo Label=%volume_1:~10,11%
echo Fs=%volume_1:~23,5%
echo Type=%volume_1:~30,10%
echo Size=%volume_1:~42,4%%volume_1:~47,2%
echo Status=%volume_1:~51,9%
echo Info=%volume_1:~62%
