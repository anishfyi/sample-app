# SpaceX Launches App - Installation Guide

This guide provides detailed instructions for setting up the development environment and building the SpaceX Launches App APK.

## Prerequisites Installation

### 1. Install Java Development Kit (JDK)

1. Download JDK 11 or newer from [Oracle's website](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) or use OpenJDK.
2. Run the installer and follow the installation instructions.
3. Set the JAVA_HOME environment variable:
   - Right-click on "This PC" or "My Computer" and select "Properties"
   - Click on "Advanced system settings"
   - Click on "Environment Variables"
   - Under "System variables", click "New"
   - Variable name: `JAVA_HOME`
   - Variable value: Path to your JDK installation (e.g., `C:\Program Files\Java\jdk-11.0.12`)
   - Click "OK"
4. Add Java to your PATH:
   - In the same Environment Variables window, find the "Path" variable under "System variables"
   - Click "Edit"
   - Click "New"
   - Add `%JAVA_HOME%\bin`
   - Click "OK" on all dialogs

### 2. Install Android Studio and Android SDK

1. Download Android Studio from [developer.android.com](https://developer.android.com/studio).
2. Run the installer and follow the installation instructions.
3. During installation, make sure to select the following components:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
4. After installation, open Android Studio and go to "SDK Manager":
   - Click on "More Actions" (three dots) or "Configure" > "SDK Manager"
   - In the "SDK Platforms" tab, select:
     - Android 13 (Tiramisu)
     - Android 12 (S)
   - In the "SDK Tools" tab, select:
     - Android SDK Build-Tools
     - Android SDK Command-line Tools
     - Android Emulator
     - Android SDK Platform-Tools
   - Click "Apply" and "OK" to download and install the selected components

### 3. Install Flutter SDK

#### Using Command Line (PowerShell)

```powershell
# Create directory for Flutter SDK
cd C:\
mkdir flutter
cd flutter

# Download Flutter SDK
Invoke-WebRequest -Uri "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.3-stable.zip" -OutFile "flutter.zip"

# Extract the ZIP file
Expand-Archive -Path "flutter.zip" -DestinationPath "C:\"

# Add Flutter to PATH
$env:Path += ";C:\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::User)

# Verify installation
flutter --version
```

#### Manual Installation

1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows).
2. Extract the ZIP file to a location on your computer (e.g., `C:\flutter`).
3. Add Flutter to your PATH:
   - Open Environment Variables as described above
   - Edit the "Path" variable
   - Add the path to the Flutter bin directory (e.g., `C:\flutter\bin`)
   - Click "OK" on all dialogs
4. Open a new Command Prompt or PowerShell window and run:
   ```
   flutter --version
   ```

### 4. Configure Flutter

1. Run Flutter doctor to check if there are any dependencies you need to install:
   ```
   flutter doctor
   ```
2. Accept Android licenses:
   ```
   flutter doctor --android-licenses
   ```

## Project Setup

1. Navigate to the project directory:
   ```
   cd path\to\spacex_launches_app
   ```

2. Update the `android/local.properties` file with the correct paths to your Flutter SDK and Android SDK:
   ```
   flutter.sdk=C:\\flutter
   sdk.dir=C:\\Users\\YourUsername\\AppData\\Local\\Android\\Sdk
   ```
   Replace `YourUsername` with your Windows username.

3. Install Flutter dependencies:
   ```
   flutter pub get
   ```

## Building the APK

### Option 1: Using the build script (Windows)

1. Run the `build_apk.bat` script by double-clicking it or running it from the command line:
   ```
   .\build_apk.bat
   ```

### Option 2: Using Flutter commands

1. Open a terminal or command prompt.
2. Navigate to the project root directory.
3. Run the following command:
   ```
   flutter build apk --release
   ```
4. If successful, the APK will be located at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

### Option 3: Using Gradle directly

1. Open a terminal or command prompt.
2. Navigate to the `android` directory within the project.
3. Run the following command:
   ```
   .\gradlew assembleRelease
   ```
4. If successful, the APK will be located at:
   ```
   app/build/outputs/apk/release/app-release.apk
   ```

## Troubleshooting

### Common Issues

1. **Flutter SDK not found**
   - Ensure the path in `local.properties` is correct
   - Make sure Flutter is properly installed and in your PATH

2. **Android SDK not found**
   - Verify the Android SDK path in `local.properties`
   - Make sure Android Studio is properly installed

3. **Gradle build failures**
   - Check that JDK is properly installed and JAVA_HOME is set
   - Try running `flutter clean` and then build again

4. **Missing dependencies**
   - Run `flutter pub get` to fetch all dependencies

### Getting Help

If you encounter issues not covered in this guide, try:
- Running `flutter doctor -v` for detailed diagnostics
- Checking the Flutter documentation at [flutter.dev](https://flutter.dev/docs)
- Searching for your error message on Stack Overflow 