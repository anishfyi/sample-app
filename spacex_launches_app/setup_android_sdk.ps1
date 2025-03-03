# PowerShell script to set up Android SDK for SpaceX Launches App

Write-Host "SpaceX Launches App - Android SDK Setup Script" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "WARNING: This script is not running as Administrator. Some operations might fail." -ForegroundColor Yellow
    Write-Host "Consider restarting this script as Administrator if you encounter permission issues." -ForegroundColor Yellow
    Write-Host
}

# Function to check if a command exists
function Test-Command {
    param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {
        if (Get-Command $command) { return $true }
    }
    catch { return $false }
    finally { $ErrorActionPreference = $oldPreference }
}

# Check if Android Studio is installed
$androidStudioPath = "$env:LOCALAPPDATA\Android\Sdk"
$androidStudioInstalled = Test-Path $androidStudioPath

if ($androidStudioInstalled) {
    Write-Host "Android SDK found at: $androidStudioPath" -ForegroundColor Green
} else {
    Write-Host "Android SDK not found at the default location." -ForegroundColor Yellow
    Write-Host "You need to install Android Studio to get the Android SDK." -ForegroundColor Yellow
    
    $installAndroidStudio = Read-Host "Do you want to download Android Studio now? (y/n)"
    if ($installAndroidStudio -eq "y") {
        # Open Android Studio download page
        Start-Process "https://developer.android.com/studio"
        Write-Host "Please download and install Android Studio, then run this script again." -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit
    } else {
        Write-Host "Please install Android Studio manually and run this script again." -ForegroundColor Yellow
        Write-Host "Download Android Studio from: https://developer.android.com/studio" -ForegroundColor Yellow
    }
}

# Update local.properties file with Android SDK path
$localPropertiesPath = "android\local.properties"
Write-Host "Updating local.properties file with Android SDK path..." -ForegroundColor Green

# Check if Flutter SDK path is already in local.properties
$flutterSdkPath = "C:\flutter"
if (-not (Test-Path $flutterSdkPath)) {
    Write-Host "Flutter SDK not found at $flutterSdkPath" -ForegroundColor Yellow
    Write-Host "You should also install Flutter SDK. Run setup_flutter.ps1 after this script." -ForegroundColor Yellow
    $flutterSdkPath = Read-Host "Enter the path to your Flutter SDK (or press Enter to use C:\flutter)"
    if ([string]::IsNullOrEmpty($flutterSdkPath)) {
        $flutterSdkPath = "C:\flutter"
    }
}

# Ask for custom Android SDK path if needed
$customAndroidSdkPath = Read-Host "Enter the path to your Android SDK (or press Enter to use $androidStudioPath)"
if ([string]::IsNullOrEmpty($customAndroidSdkPath)) {
    $androidSdkPath = $androidStudioPath
} else {
    $androidSdkPath = $customAndroidSdkPath
}

# Create or update local.properties
$localPropertiesContent = @"
flutter.sdk=$($flutterSdkPath.Replace("\", "\\"))
sdk.dir=$($androidSdkPath.Replace("\", "\\"))
"@

Set-Content -Path $localPropertiesPath -Value $localPropertiesContent
Write-Host "local.properties file updated with Android SDK path." -ForegroundColor Green

# Check for Android SDK components
Write-Host "Checking for required Android SDK components..." -ForegroundColor Green

$sdkManagerPath = "$androidSdkPath\cmdline-tools\latest\bin\sdkmanager.bat"
if (Test-Path $sdkManagerPath) {
    Write-Host "SDK Manager found. You can use it to install required components." -ForegroundColor Green
    
    $installComponents = Read-Host "Do you want to install required Android SDK components now? (y/n)"
    if ($installComponents -eq "y") {
        Write-Host "Installing required Android SDK components..." -ForegroundColor Green
        
        # Accept licenses first
        Write-Host "Accepting Android SDK licenses..." -ForegroundColor Yellow
        echo y | & $sdkManagerPath --licenses
        
        # Install required components
        Write-Host "Installing platform tools..." -ForegroundColor Yellow
        & $sdkManagerPath "platform-tools"
        
        Write-Host "Installing build tools..." -ForegroundColor Yellow
        & $sdkManagerPath "build-tools;33.0.0"
        
        Write-Host "Installing platforms..." -ForegroundColor Yellow
        & $sdkManagerPath "platforms;android-33"
        
        Write-Host "Android SDK components installed." -ForegroundColor Green
    }
} else {
    Write-Host "SDK Manager not found at $sdkManagerPath" -ForegroundColor Yellow
    Write-Host "You may need to install command-line tools or use Android Studio to install required components." -ForegroundColor Yellow
    Write-Host "Required components:" -ForegroundColor Yellow
    Write-Host "- Android SDK Platform-Tools" -ForegroundColor Yellow
    Write-Host "- Android SDK Build-Tools 33.0.0" -ForegroundColor Yellow
    Write-Host "- Android SDK Platform 33" -ForegroundColor Yellow
}

Write-Host
Write-Host "Android SDK setup completed." -ForegroundColor Cyan
Write-Host "Make sure you have also installed the Flutter SDK by running setup_flutter.ps1" -ForegroundColor Cyan
Write-Host "After both SDKs are installed, you can build the APK using one of the methods in BUILD_APK_README.md" -ForegroundColor Cyan

Read-Host "Press Enter to exit" 