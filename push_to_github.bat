@echo off
title Push Easymator Engine to GitHub
echo ========================================================
echo   Pushing Easymator Engine to GitHub
echo ========================================================
echo.
cd /d "%~dp0"
echo Executing git push -u origin main...
git push -u origin main
echo.
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Successfully pushed to GitHub!
) else (
    echo [ERROR] Push failed. Check credentials or network.
)
echo.
pause
