# PosApp Deployment Guide

## Overview

PosApp is a portable Point of Sale application that can run on any Windows PC without requiring Java installation. The application includes a bundled Java Runtime Environment (JRE) for maximum compatibility and ease of deployment.

## 🎯 Deployment Options

### ✅ Portable Installation (Recommended - No Java Required)

This is the recommended deployment method for maximum compatibility and ease of use.

#### Package Details

- **Location**: Project root directory (`PosApp-Portable-1.0.0-Windows.zip`)
- **Includes**: 
  - Complete PosApp application
  - Bundled Java Runtime (when JRE is added)
  - Launcher scripts
  - Documentation
- **Works on**: Any Windows PC (Windows 7 or later, 64-bit)
- **Requirements**: None - runs out of the box!

#### Installation Steps for Any PC

1. **Copy the ZIP file** to the target computer
   - USB drive
   - Network share
   - Cloud storage (Google Drive, Dropbox, etc.)
   - Email (if size permits)

2. **Extract** to any location
   - Desktop
   - `C:\Program Files\PosApp`
   - USB drive
   - Any other folder of your choice

3. **Run** `PosApp.bat` from the extracted folder
   - Double-click the file to start
   - Works immediately after extraction

4. **Optional**: Create a desktop shortcut to `PosApp.bat`
   - Right-click on `PosApp.bat`
   - Select "Send to" → "Desktop (create shortcut)"

## 🚀 Building the Portable Package

### Prerequisites

- Java Development Kit (JDK) 17 or later
- Apache Maven 3.6 or later
- Git (for cloning the repository)

### Build Steps

#### On Linux/Mac:

```bash
# Clone the repository
git clone https://github.com/samadul2011/PosApp-Portable.git
cd PosApp-Portable

# Run the build script
./build-portable.sh
```

#### On Windows:

```batch
REM Clone the repository
git clone https://github.com/samadul2011/PosApp-Portable.git
cd PosApp-Portable

REM Run the build script
build-portable.bat
```

### Adding Bundled JRE (Optional but Recommended)

To create a truly portable package that works without any Java installation:

1. **Download JRE 17 or later** from [Adoptium](https://adoptium.net/):
   - Select: Java 17 (LTS) or later
   - Platform: Windows x64
   - Package: JRE (not JDK)
   - Format: ZIP

2. **Extract the JRE**:
   ```bash
   # Extract to the package directory
   unzip jre-17-windows-x64.zip
   mv jre-17 target/package/jre
   ```

3. **Rebuild the package**:
   ```bash
   ./build-portable.sh
   ```

The final package will now include the bundled JRE and work on any Windows PC.

## 📦 Package Contents

After building, the ZIP file contains:

```
PosApp-Portable-1.0.0-Windows.zip
├── PosApp.bat          # Windows launcher (double-click to run)
├── PosApp.sh           # Linux/Mac launcher (for testing)
├── README.txt          # User documentation
├── app.jar             # Main application JAR
├── libs/               # Application dependencies
│   ├── javafx-controls-17.0.2.jar
│   ├── javafx-fxml-17.0.2.jar
│   └── ... (other dependencies)
└── jre/                # Bundled Java Runtime (if added)
    ├── bin/
    ├── lib/
    └── ... (JRE files)
```

## ✨ Key Features

### Portability
- ✅ No installation required
- ✅ No administrator rights needed
- ✅ Can run from USB drive or any folder
- ✅ No registry modifications
- ✅ No system files modified

### Self-Contained
- ✅ No Java installation required (with bundled JRE)
- ✅ Includes complete Java runtime
- ✅ All dependencies bundled
- ✅ Works offline

### Easy Distribution
- ✅ Single ZIP file
- ✅ Simple extraction process
- ✅ Immediate execution
- ✅ Can be shared via any file transfer method

## 🔧 Troubleshooting

### Application doesn't start

1. **Verify extraction**: Make sure all files are extracted (not running from within ZIP)
2. **Check antivirus**: Some antivirus software may quarantine files
3. **Disk space**: Verify you have enough disk space (minimum 500MB)
4. **Run as administrator**: Try right-click → "Run as administrator"

### "Java not found" error (without bundled JRE)

If the bundled JRE is not included:
1. Install Java 17 or later from [Adoptium](https://adoptium.net/)
2. Or rebuild the package with bundled JRE (see above)

### Performance issues

- Close unnecessary applications
- Ensure adequate RAM (2GB minimum, 4GB recommended)
- Run from local drive instead of USB for better performance

## 🔄 Updates and Maintenance

To update the application:

1. Download the new version ZIP file
2. Extract to a new location (or backup and replace old installation)
3. Run the new `PosApp.bat`

Your data and settings are stored separately and won't be affected by updates (if data persistence is implemented in future versions).

## 📝 Development

### Project Structure

```
PosApp-Portable/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── posapp/
│       │           └── PosApp.java
│       └── resources/
├── pom.xml                 # Maven configuration
├── build-portable.sh       # Linux/Mac build script
├── build-portable.bat      # Windows build script
├── DEPLOYMENT.md          # This file
└── README.md              # Project overview
```

### Building from Source

```bash
# Build the application only (without creating portable package)
mvn clean package

# Run the application (requires Java 17+)
mvn javafx:run

# Create portable package
./build-portable.sh  # or build-portable.bat on Windows
```

## 📞 Support

For issues, questions, or suggestions:
- Email: samadul2011@gmail.com
- GitHub Issues: [Create an issue](https://github.com/samadul2011/PosApp-Portable/issues)

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- JavaFX for the UI framework
- Eclipse Adoptium for providing open-source JRE builds
- Maven for build automation
