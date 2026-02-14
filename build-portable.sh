#!/bin/bash
# Build script for creating portable PosApp distribution
# This script creates a portable Windows package with bundled JRE

set -e

echo "========================================"
echo "PosApp Portable Package Builder"
echo "========================================"
echo ""

# Configuration
APP_NAME="PosApp"
APP_VERSION="1.0.0"
MAIN_CLASS="com.posapp.PosApp"
OUTPUT_DIR="./target/portable"
PACKAGE_DIR="./target/package"
DIST_DIR="."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Cleaning previous builds...${NC}"
rm -rf target
rm -f PosApp-Portable-*.zip

echo -e "${BLUE}Step 2: Building application with Maven...${NC}"
mvn clean package

if [ ! -f "target/${APP_NAME}-${APP_VERSION}.jar" ]; then
    echo "Error: JAR file not found after build"
    exit 1
fi

echo -e "${GREEN}✓ Application built successfully${NC}"
echo ""

echo -e "${BLUE}Step 3: Creating portable package structure...${NC}"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$PACKAGE_DIR"

# Copy JAR and dependencies
cp "target/${APP_NAME}-${APP_VERSION}.jar" "$PACKAGE_DIR/app.jar"
cp -r target/libs "$PACKAGE_DIR/" 2>/dev/null || true

echo -e "${GREEN}✓ Package structure created${NC}"
echo ""

echo -e "${BLUE}Step 4: Creating launcher script...${NC}"

# Create Windows batch launcher
cat > "$PACKAGE_DIR/PosApp.bat" << 'EOF'
@echo off
REM PosApp Launcher Script
REM This script launches PosApp using the bundled Java Runtime

setlocal

REM Get the directory where this script is located
set "APP_DIR=%~dp0"

REM Check if bundled JRE exists
if exist "%APP_DIR%jre\bin\java.exe" (
    set "JAVA_CMD=%APP_DIR%jre\bin\java.exe"
    echo Using bundled Java Runtime...
) else (
    REM Fall back to system Java if bundled JRE not found
    set "JAVA_CMD=java"
    echo Bundled JRE not found, using system Java...
)

REM Build classpath
set "CLASSPATH=%APP_DIR%app.jar"
for %%i in ("%APP_DIR%libs\*.jar") do (
    set "CLASSPATH=!CLASSPATH!;%%i"
)

REM Launch the application
echo Starting PosApp...
"%JAVA_CMD%" --module-path "%APP_DIR%libs" --add-modules javafx.controls,javafx.fxml -cp "%CLASSPATH%" com.posapp.PosApp

if errorlevel 1 (
    echo.
    echo Error: Failed to start PosApp
    pause
)

endlocal
EOF

# Create Linux/Mac launcher for testing
cat > "$PACKAGE_DIR/PosApp.sh" << 'EOF'
#!/bin/bash
# PosApp Launcher Script for Linux/Mac
# This script launches PosApp using the bundled Java Runtime

# Get the directory where this script is located
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if bundled JRE exists
if [ -f "$APP_DIR/jre/bin/java" ]; then
    JAVA_CMD="$APP_DIR/jre/bin/java"
    echo "Using bundled Java Runtime..."
else
    # Fall back to system Java if bundled JRE not found
    JAVA_CMD="java"
    echo "Bundled JRE not found, using system Java..."
fi

# Build classpath
CLASSPATH="$APP_DIR/app.jar"
for jar in "$APP_DIR/libs"/*.jar; do
    CLASSPATH="$CLASSPATH:$jar"
done

# Launch the application
echo "Starting PosApp..."
"$JAVA_CMD" --module-path "$APP_DIR/libs" --add-modules javafx.controls,javafx.fxml -cp "$CLASSPATH" com.posapp.PosApp
EOF

chmod +x "$PACKAGE_DIR/PosApp.sh"

echo -e "${GREEN}✓ Launcher scripts created${NC}"
echo ""

echo -e "${BLUE}Step 5: Creating README for distribution...${NC}"

cat > "$PACKAGE_DIR/README.txt" << 'EOF'
================================================================================
                    PosApp - Portable Installation
================================================================================

Thank you for downloading PosApp!

SYSTEM REQUIREMENTS:
-------------------
- Windows 7 or later (64-bit)
- No Java installation required (bundled with this package)
- Minimum 2GB RAM recommended

INSTALLATION STEPS:
------------------
1. Extract this ZIP file to your desired location:
   - Desktop
   - C:\Program Files\PosApp
   - USB Drive
   - Any other folder

2. Run PosApp:
   - Double-click "PosApp.bat" to start the application
   - On first run, Windows may show a security warning - click "More info" 
     and "Run anyway"

3. (Optional) Create a desktop shortcut:
   - Right-click "PosApp.bat"
   - Select "Send to" > "Desktop (create shortcut)"

PORTABLE FEATURES:
-----------------
✓ No installation required
✓ No administrator rights needed
✓ Includes complete Java runtime
✓ Can run from USB drive or any folder
✓ No registry modifications
✓ No system files modified

TROUBLESHOOTING:
---------------
If the application doesn't start:

1. Make sure all files are extracted (not running from within ZIP)
2. Check that antivirus hasn't quarantined any files
3. Verify you have enough disk space (minimum 500MB)
4. Try running as administrator (right-click > Run as administrator)

For additional support, please contact: samadul2011@gmail.com

VERSION: 1.0.0
================================================================================
EOF

echo -e "${GREEN}✓ README created${NC}"
echo ""

echo -e "${BLUE}Step 6: Creating portable ZIP package...${NC}"

# Create the ZIP file
cd target
ZIP_NAME="../PosApp-Portable-${APP_VERSION}-Windows.zip"
zip -r "$ZIP_NAME" package/
cd ..

echo -e "${GREEN}✓ Portable package created: PosApp-Portable-${APP_VERSION}-Windows.zip${NC}"
echo ""

echo "========================================"
echo -e "${GREEN}Build Complete!${NC}"
echo "========================================"
echo ""
echo "Package location: $(pwd)/PosApp-Portable-${APP_VERSION}-Windows.zip"
echo "Package size: $(du -h PosApp-Portable-${APP_VERSION}-Windows.zip | cut -f1)"
echo ""
echo "NOTE: This package does NOT include a bundled JRE yet."
echo "      To add a bundled JRE:"
echo "      1. Download JRE 17+ from https://adoptium.net/"
echo "      2. Extract it to 'target/package/jre/'"
echo "      3. Re-run this script to create the final package"
echo ""
echo "To test without bundled JRE (requires Java 17+ installed):"
echo "  1. Extract the ZIP file"
echo "  2. Run PosApp.bat (Windows) or PosApp.sh (Linux/Mac)"
echo ""
