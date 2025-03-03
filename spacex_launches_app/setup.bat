@echo off
echo SpaceX Launches App - Setup Script
echo ================================
echo.

echo This script will guide you through the setup process for building the SpaceX Launches App APK.
echo.

:MENU
echo Please select an option:
echo 1. Check environment (Java, Flutter, Android SDK)
echo 2. Set up Flutter SDK
echo 3. Set up Android SDK
echo 4. Build APK
echo 5. View installation guide
echo 6. Exit
echo.

set /p OPTION=Enter option number: 

if "%OPTION%"=="1" goto CHECK_ENV
if "%OPTION%"=="2" goto SETUP_FLUTTER
if "%OPTION%"=="3" goto SETUP_ANDROID
if "%OPTION%"=="4" goto BUILD_APK
if "%OPTION%"=="5" goto VIEW_GUIDE
if "%OPTION%"=="6" goto EXIT

echo Invalid option. Please try again.
echo.
goto MENU

:CHECK_ENV
echo.
echo Checking environment...
call check_environment.bat
echo.
goto MENU

:SETUP_FLUTTER
echo.
echo Setting up Flutter SDK...
powershell -ExecutionPolicy Bypass -File setup_flutter.ps1
echo.
goto MENU

:SETUP_ANDROID
echo.
echo Setting up Android SDK...
powershell -ExecutionPolicy Bypass -File setup_android_sdk.ps1
echo.
goto MENU

:BUILD_APK
echo.
echo Building APK...
echo.
echo Please select a build method:
echo 1. Use build_apk.bat script
echo 2. Use Flutter command (requires Flutter in PATH)
echo 3. Use Gradle directly (requires Java in PATH)
echo 4. Back to main menu
echo.

set /p BUILD_OPTION=Enter option number: 

if "%BUILD_OPTION%"=="1" (
    call build_apk.bat
    goto MENU
)
if "%BUILD_OPTION%"=="2" (
    echo Running 'flutter build apk --release'...
    flutter build apk --release
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo APK build successful!
        echo The APK file is located at:
        echo build\app\outputs\flutter-apk\app-release.apk
    ) else (
        echo.
        echo APK build failed with error code %ERRORLEVEL%
    )
    pause
    goto MENU
)
if "%BUILD_OPTION%"=="3" (
    echo Running Gradle build...
    cd android
    call gradlew assembleRelease
    cd ..
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo APK build successful!
        echo The APK file is located at:
        echo android\app\build\outputs\apk\release\app-release.apk
    ) else (
        echo.
        echo APK build failed with error code %ERRORLEVEL%
    )
    pause
    goto MENU
)
if "%BUILD_OPTION%"=="4" goto MENU

echo Invalid option. Please try again.
echo.
goto BUILD_APK

:VIEW_GUIDE
echo.
echo Opening installation guide...
start "" INSTALLATION_GUIDE.md
echo.
goto MENU

:EXIT
echo.
echo Thank you for using the SpaceX Launches App setup script.
echo.
exit /b 0 