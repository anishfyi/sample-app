# PowerShell script to set up Flutter for SpaceX Launches App

Write-Host "SpaceX Launches App - Flutter Setup Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
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

# Create directory for Flutter SDK if it doesn't exist
$flutterPath = "C:\flutter"
if (-not (Test-Path $flutterPath)) {
    Write-Host "Creating Flutter directory at $flutterPath..." -ForegroundColor Green
    New-Item -Path $flutterPath -ItemType Directory -Force | Out-Null
}

# Check if Flutter is already installed
if (Test-Command flutter) {
    Write-Host "Flutter is already installed. Checking version..." -ForegroundColor Green
    flutter --version
    Write-Host
    $installFlutter = Read-Host "Do you want to reinstall Flutter? (y/n)"
    if ($installFlutter -ne "y") {
        Write-Host "Skipping Flutter installation." -ForegroundColor Yellow
        $skipFlutterInstall = $true
    }
}

# Download and install Flutter SDK
if (-not $skipFlutterInstall) {
    Write-Host "Downloading Flutter SDK..." -ForegroundColor Green
    $flutterZip = "$flutterPath\flutter.zip"
    $downloadUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.3-stable.zip"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $flutterZip
        Write-Host "Download completed. Extracting..." -ForegroundColor Green
        
        # Extract the ZIP file
        Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force
        
        # Clean up the ZIP file
        Remove-Item $flutterZip
        
        Write-Host "Flutter SDK extracted to $flutterPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error downloading or extracting Flutter SDK: $_" -ForegroundColor Red
        Write-Host "Please download Flutter manually from https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Yellow
    }
}

# Add Flutter to PATH if not already there
$userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if (-not $userPath.Contains("$flutterPath\bin")) {
    Write-Host "Adding Flutter to PATH..." -ForegroundColor Green
    $newPath = "$userPath;$flutterPath\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
    $env:Path = "$env:Path;$flutterPath\bin"
    Write-Host "Flutter added to PATH. You may need to restart your terminal for changes to take effect." -ForegroundColor Yellow
}

# Update local.properties file
$localPropertiesPath = "android\local.properties"
Write-Host "Updating local.properties file..." -ForegroundColor Green

$username = $env:USERNAME
$androidSdkPath = "$env:LOCALAPPDATA\Android\Sdk"

$localPropertiesContent = @"
flutter.sdk=C:\\flutter
sdk.dir=$androidSdkPath
"@

Set-Content -Path $localPropertiesPath -Value $localPropertiesContent
Write-Host "local.properties file updated." -ForegroundColor Green

# Run Flutter doctor
Write-Host "Running Flutter doctor to check setup..." -ForegroundColor Green
try {
    flutter doctor
}
catch {
    Write-Host "Error running Flutter doctor. Make sure Flutter is in your PATH." -ForegroundColor Red
}

# Install Flutter dependencies
Write-Host "Installing Flutter dependencies..." -ForegroundColor Green
try {
    flutter pub get
    Write-Host "Dependencies installed successfully." -ForegroundColor Green
}
catch {
    Write-Host "Error installing dependencies: $_" -ForegroundColor Red
}

Write-Host
Write-Host "Setup completed. You can now build the APK using one of the following methods:" -ForegroundColor Cyan
Write-Host "1. Run build_apk.bat" -ForegroundColor Cyan
Write-Host "2. Run 'flutter build apk --release'" -ForegroundColor Cyan
Write-Host "3. Navigate to android directory and run 'gradlew assembleRelease'" -ForegroundColor Cyan
Write-Host
Write-Host "For more information, see BUILD_APK_README.md and INSTALLATION_GUIDE.md" -ForegroundColor Cyan

Read-Host "Press Enter to exit" 