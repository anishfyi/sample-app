@echo off
echo Building SpaceX Launches App APK...

cd android
call gradlew assembleRelease

if %ERRORLEVEL% == 0 (
    echo.
    echo APK build successful!
    echo.
    echo The APK file is located at:
    echo app\build\outputs\apk\release\app-release.apk
) else (
    echo.
    echo APK build failed with error code %ERRORLEVEL%
)

pause 