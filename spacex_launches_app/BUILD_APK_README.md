# Building the SpaceX Launches App APK

This document provides instructions on how to build an APK file from the SpaceX Launches app.

## Prerequisites

Before you can build the APK, you need to have the following installed:

1. **Flutter SDK** - Download and install from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. **Android SDK** - Install via Android Studio or command line tools
3. **Java Development Kit (JDK)** - Version 8 or newer

## Setup

1. Update the `android/local.properties` file with the correct paths to your Flutter SDK and Android SDK:

```
flutter.sdk=C:\\path\\to\\your\\flutter
sdk.dir=C:\\path\\to\\your\\Android\\sdk
```

Replace the paths with the actual locations on your system.

## Building the APK

### Option 1: Using the build script (Windows)

1. Run the `build_apk.bat` script by double-clicking it or running it from the command line.
2. Wait for the build process to complete.
3. If successful, the APK will be located at:
   ```
   android/app/build/outputs/apk/release/app-release.apk
   ```

### Option 2: Using Flutter commands

1. Open a terminal or command prompt.
2. Navigate to the project root directory.
3. Run the following command:
   ```
   flutter build apk
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
   ./gradlew assembleRelease
   ```
   On Windows, use:
   ```
   gradlew assembleRelease
   ```
4. If successful, the APK will be located at:
   ```
   app/build/outputs/apk/release/app-release.apk
   ```

## Installing the APK

To install the APK on an Android device:

1. Transfer the APK file to your Android device.
2. On your device, navigate to the APK file and tap on it.
3. Follow the on-screen instructions to install the app.

Note: You may need to enable "Install from Unknown Sources" in your device settings. 