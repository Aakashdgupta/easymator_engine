@echo off
title Publish easymator_core to pub.dev
echo ========================================================
echo   Publishing easymator_core to pub.dev
echo ========================================================
echo.
cd /d "%~dp0easymator_core"
echo Running pub.dev verification...
dart pub publish --dry-run
echo.
echo If everything looks good above, proceed with publishing:
dart pub publish
pause
