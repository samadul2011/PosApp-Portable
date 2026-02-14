@echo off
REM Build script for creating portable PosApp distribution on Windows
REM This script creates a portable Windows package with bundled JRE

setlocal enabledelayedexpansion

echo ========================================
echo PosApp Portable Package Builder
echo ========================================
echo.

REM Configuration
set "APP_NAME=PosApp"
set "APP_VERSION=1.0.0"
set "OUTPUT_DIR=target\portable"
set "PACKAGE_DIR=target\package"

echo Step 1: Cleaning previous builds...
if exist target rmdir /s /q target
if exist PosApp-Portable-*.zip del /q PosApp-Portable-*.zip

echo Step 2: Building application with Maven...
call mvn clean package

if not exist "target\%APP_NAME%-%APP_VERSION%.jar" (
    echo Error: JAR file not found after build
    exit /b 1
)

echo [32m✓ Application built successfully[0m
echo.

echo Step 3: Creating portable package structure...
mkdir "%OUTPUT_DIR%" 2>nul
mkdir "%PACKAGE_DIR%" 2>nul

REM Copy JAR and dependencies
copy "target\%APP_NAME%-%APP_VERSION%.jar" "%PACKAGE_DIR%\app.jar" >nul
if exist "target\libs" xcopy /E /I /Y "target\libs" "%PACKAGE_DIR%\libs" >nul

echo [32m✓ Package structure created[0m
echo.

echo Step 4: Creating launcher script...

REM Create Windows batch launcher
(
echo @echo off
echo REM PosApp Launcher Script
echo REM This script launches PosApp using the bundled Java Runtime
echo.
echo setlocal
echo.
echo REM Get the directory where this script is located
echo set "APP_DIR=%%~dp0"
echo.
echo REM Check if bundled JRE exists
echo if exist "%%APP_DIR%%jre\bin\java.exe" ^(
echo     set "JAVA_CMD=%%APP_DIR%%jre\bin\java.exe"
echo     echo Using bundled Java Runtime...
echo ^) else ^(
echo     REM Fall back to system Java if bundled JRE not found
echo     set "JAVA_CMD=java"
echo     echo Bundled JRE not found, using system Java...
echo ^)
echo.
echo REM Build classpath
echo set "CLASSPATH=%%APP_DIR%%app.jar"
echo for %%%%i in ^("%%APP_DIR%%libs\*.jar"^) do ^(
echo     set "CLASSPATH=!CLASSPATH!;%%%%i"
echo ^)
echo.
echo REM Launch the application
echo echo Starting PosApp...
echo "%%JAVA_CMD%%" --module-path "%%APP_DIR%%libs" --add-modules javafx.controls,javafx.fxml -cp "%%CLASSPATH%%" com.posapp.PosApp
echo.
echo if errorlevel 1 ^(
echo     echo.
echo     echo Error: Failed to start PosApp
echo     pause
echo ^)
echo.
echo endlocal
) > "%PACKAGE_DIR%\PosApp.bat"

echo [32m✓ Launcher script created[0m
echo.

echo Step 5: Creating README for distribution...

(
echo ================================================================================
echo                     PosApp - Portable Installation
echo ================================================================================
echo.
echo Thank you for downloading PosApp!
echo.
echo SYSTEM REQUIREMENTS:
echo -------------------
echo - Windows 7 or later ^(64-bit^)
echo - No Java installation required ^(bundled with this package^)
echo - Minimum 2GB RAM recommended
echo.
echo INSTALLATION STEPS:
echo ------------------
echo 1. Extract this ZIP file to your desired location:
echo    - Desktop
echo    - C:\Program Files\PosApp
echo    - USB Drive
echo    - Any other folder
echo.
echo 2. Run PosApp:
echo    - Double-click "PosApp.bat" to start the application
echo    - On first run, Windows may show a security warning - click "More info" 
echo      and "Run anyway"
echo.
echo 3. ^(Optional^) Create a desktop shortcut:
echo    - Right-click "PosApp.bat"
echo    - Select "Send to" ^> "Desktop ^(create shortcut^)"
echo.
echo PORTABLE FEATURES:
echo -----------------
echo ✓ No installation required
echo ✓ No administrator rights needed
echo ✓ Includes complete Java runtime
echo ✓ Can run from USB drive or any folder
echo ✓ No registry modifications
echo ✓ No system files modified
echo.
echo TROUBLESHOOTING:
echo ---------------
echo If the application doesn't start:
echo.
echo 1. Make sure all files are extracted ^(not running from within ZIP^)
echo 2. Check that antivirus hasn't quarantined any files
echo 3. Verify you have enough disk space ^(minimum 500MB^)
echo 4. Try running as administrator ^(right-click ^> Run as administrator^)
echo.
echo For additional support, please contact: samadul2011@gmail.com
echo.
echo VERSION: 1.0.0
echo ================================================================================
) > "%PACKAGE_DIR%\README.txt"

echo [32m✓ README created[0m
echo.

echo Step 6: Creating portable ZIP package...

REM Create the ZIP file using PowerShell
powershell -Command "Compress-Archive -Path 'target\package\*' -DestinationPath 'PosApp-Portable-%APP_VERSION%-Windows.zip' -Force"

if exist "PosApp-Portable-%APP_VERSION%-Windows.zip" (
    echo [32m✓ Portable package created: PosApp-Portable-%APP_VERSION%-Windows.zip[0m
) else (
    echo [31mError: Failed to create ZIP package[0m
    exit /b 1
)

echo.
echo ========================================
echo [32mBuild Complete![0m
echo ========================================
echo.
echo Package location: %CD%\PosApp-Portable-%APP_VERSION%-Windows.zip

for %%A in ("PosApp-Portable-%APP_VERSION%-Windows.zip") do echo Package size: %%~zA bytes

echo.
echo NOTE: This package does NOT include a bundled JRE yet.
echo       To add a bundled JRE:
echo       1. Download JRE 17+ from https://adoptium.net/
echo       2. Extract it to 'target\package\jre\'
echo       3. Re-run this script to create the final package
echo.
echo To test without bundled JRE ^(requires Java 17+ installed^):
echo   1. Extract the ZIP file
echo   2. Run PosApp.bat
echo.

endlocal
