@echo off
echo Checking environment for SpaceX Launches App build...
echo.

REM Check Java installation
echo Checking Java installation...
java -version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java is not installed or not in PATH.
    echo Please install JDK and set JAVA_HOME environment variable.
    echo See INSTALLATION_GUIDE.md for details.
    echo.
) else (
    echo [OK] Java is installed.
    echo.
)

REM Check JAVA_HOME
echo Checking JAVA_HOME environment variable...
if "%JAVA_HOME%" == "" (
    echo [ERROR] JAVA_HOME environment variable is not set.
    echo Please set JAVA_HOME to your JDK installation directory.
    echo See INSTALLATION_GUIDE.md for details.
    echo.
) else (
    echo [OK] JAVA_HOME is set to: %JAVA_HOME%
    echo.
)

REM Check Flutter installation
echo Checking Flutter installation...
flutter --version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH.
    echo Please install Flutter SDK and add it to your PATH.
    echo See INSTALLATION_GUIDE.md for details.
    echo.
) else (
    echo [OK] Flutter is installed.
    echo.
)

REM Check Android SDK
echo Checking Android SDK...
if exist "%LOCALAPPDATA%\Android\Sdk" (
    echo [OK] Android SDK found at: %LOCALAPPDATA%\Android\Sdk
    echo.
) else (
    echo [WARNING] Android SDK not found at default location.
    echo Please make sure Android SDK is installed and update local.properties file.
    echo See INSTALLATION_GUIDE.md for details.
    echo.
)

REM Check local.properties
echo Checking local.properties file...
if exist "android\local.properties" (
    echo [OK] local.properties file exists.
    echo Please make sure it contains correct paths to Flutter SDK and Android SDK.
    echo.
) else (
    echo [ERROR] local.properties file not found.
    echo Please create this file in the android directory with the following content:
    echo flutter.sdk=C:\\path\\to\\flutter
    echo sdk.dir=C:\\path\\to\\Android\\Sdk
    echo.
)

REM Run Flutter doctor
echo Running Flutter doctor for detailed diagnostics...
echo.
flutter doctor -v 2>nul

echo.
echo Environment check completed.
echo If there are any issues, please refer to INSTALLATION_GUIDE.md for solutions.
echo.

pause 