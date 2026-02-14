# Quick Start Guide for Developers

## Prerequisites

- Java Development Kit (JDK) 17 or later
- Apache Maven 3.6 or later
- Git

## Building the Portable Package

### Basic Build (without bundled JRE)

```bash
# Clone the repository
git clone https://github.com/samadul2011/PosApp-Portable.git
cd PosApp-Portable

# Build the portable package
./build-portable.sh  # Linux/Mac
# or
build-portable.bat   # Windows
```

This creates `PosApp-Portable-1.0.0-Windows.zip` in the project root.

### Full Build (with bundled JRE)

To create a truly portable package that doesn't require Java installation:

```bash
# First, build the basic package
./build-portable.sh

# Then, download and bundle JRE
./bundle-jre.sh
```

This will:
1. Download the latest JRE 17 from Eclipse Adoptium
2. Extract and bundle it with the application
3. Rebuild the portable package

The final package will be completely self-contained.

## Testing the Application

### Without extraction (requires Java 17+)

```bash
# Build and run directly
mvn javafx:run
```

### With extraction (portable mode)

```bash
# Extract the ZIP
unzip PosApp-Portable-1.0.0-Windows.zip -d test-install

# Run the application
cd test-install/package
./PosApp.sh  # Linux/Mac
# or double-click PosApp.bat on Windows
```

## Project Structure

```
PosApp-Portable/
├── src/
│   └── main/
│       ├── java/com/posapp/
│       │   └── PosApp.java          # Main application
│       └── resources/                # Application resources
├── .github/workflows/
│   └── build.yml                     # GitHub Actions workflow
├── pom.xml                           # Maven configuration
├── build-portable.sh                 # Linux/Mac build script
├── build-portable.bat                # Windows build script
├── bundle-jre.sh                     # JRE bundler script
├── DEPLOYMENT.md                     # Deployment guide
├── QUICKSTART.md                     # This file
├── README.md                         # Project overview
└── .gitignore                        # Git ignore rules
```

## Maven Commands

```bash
# Clean build
mvn clean

# Compile
mvn compile

# Package (create JAR)
mvn package

# Run with JavaFX plugin
mvn javafx:run

# Copy dependencies
mvn dependency:copy-dependencies
```

## Customization

### Change Application Name

1. Update `APP_NAME` in `build-portable.sh` and `build-portable.bat`
2. Update `<artifactId>` in `pom.xml`
3. Rebuild the package

### Change Application Version

1. Update `APP_VERSION` in build scripts
2. Update `<version>` in `pom.xml`
3. Update version in `PosApp.java` welcome message
4. Rebuild the package

### Add Dependencies

1. Add dependency to `pom.xml`:
   ```xml
   <dependency>
       <groupId>group.id</groupId>
       <artifactId>artifact-id</artifactId>
       <version>1.0.0</version>
   </dependency>
   ```

2. Rebuild: `mvn clean package`

### Modify UI

Edit `src/main/java/com/posapp/PosApp.java`:
- Modify `start()` method for UI changes
- Add new methods for functionality
- Update event handlers

## Troubleshooting

### Build fails with "JavaFX not found"

Make sure you're using JDK 17 or later. JavaFX is not included in JDK by default and is pulled as a Maven dependency.

### "mvn: command not found"

Install Maven:
- **Ubuntu/Debian**: `sudo apt install maven`
- **macOS**: `brew install maven`
- **Windows**: Download from https://maven.apache.org/

### Application doesn't start

1. Check Java version: `java -version` (should be 17+)
2. Verify all files extracted properly
3. Check for errors in console output

### Package too large

The package includes:
- Application JAR: ~6 KB
- JavaFX libraries: ~7 MB
- Bundled JRE (if added): ~40-50 MB

To reduce size:
- Don't bundle JRE (requires Java on target PC)
- Use jlink to create minimal JRE

## CI/CD

The project includes GitHub Actions workflow (`.github/workflows/build.yml`) that:
- Builds on every push
- Creates artifacts for download
- Automatically creates releases from tags

### Create a Release

```bash
# Tag the version
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions will automatically:
# 1. Build the portable package
# 2. Create a release
# 3. Upload the package as release asset
```

## Next Steps

1. **Customize the UI** - Modify PosApp.java to match your needs
2. **Add features** - Implement inventory, reporting, etc.
3. **Add database** - Integrate H2, SQLite, or another embedded database
4. **Bundle JRE** - Run `./bundle-jre.sh` for true portability
5. **Create release** - Tag and push to trigger automatic release

## Support

- **Issues**: https://github.com/samadul2011/PosApp-Portable/issues
- **Email**: samadul2011@gmail.com

## License

MIT License - See LICENSE file for details
