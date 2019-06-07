@echo off
git pull
git add .
git commit -m "Update"
if %errorlevel% equ 0 git push
