@echo off
title Publish easymator_flutter to pub.dev
echo ========================================================
echo   Publishing easymator_flutter to pub.dev
echo ========================================================
echo.
cd /d "%~dp0easymator_flutter"
echo Running pub.dev verification...
flutter pub publish --dry-run
echo.
echo If everything looks good above, proceed with publishing:
flutter pub publish
pause
