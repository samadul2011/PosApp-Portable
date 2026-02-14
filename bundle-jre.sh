#!/bin/bash
# Script to download and bundle JRE with PosApp
# This creates a fully portable package that works on any Windows PC

set -e

echo "========================================"
echo "PosApp JRE Bundler"
echo "========================================"
echo ""

# Configuration
JRE_VERSION="17.0.10+7"
JRE_URL="https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jre/hotspot/normal/eclipse"
PACKAGE_DIR="./target/package"
JRE_DIR="$PACKAGE_DIR/jre"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if package exists
if [ ! -d "$PACKAGE_DIR" ]; then
    echo -e "${YELLOW}Warning: Package directory not found.${NC}"
    echo "Please run ./build-portable.sh first to create the package."
    exit 1
fi

echo -e "${BLUE}Step 1: Checking for existing JRE...${NC}"
if [ -d "$JRE_DIR" ]; then
    echo -e "${YELLOW}JRE already exists in package. Remove it? (y/n)${NC}"
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        rm -rf "$JRE_DIR"
        echo "Removed existing JRE."
    else
        echo "Keeping existing JRE. Exiting."
        exit 0
    fi
fi

echo -e "${BLUE}Step 2: Downloading JRE from Eclipse Adoptium...${NC}"
echo "URL: $JRE_URL"
echo "This may take a few minutes depending on your connection..."
echo ""

# Download JRE
if command -v wget &> /dev/null; then
    wget -O /tmp/jre.zip "$JRE_URL" --progress=bar:force
elif command -v curl &> /dev/null; then
    curl -L -o /tmp/jre.zip "$JRE_URL" --progress-bar
else
    echo "Error: Neither wget nor curl is available. Please install one of them."
    exit 1
fi

if [ ! -f "/tmp/jre.zip" ]; then
    echo "Error: Failed to download JRE"
    exit 1
fi

echo -e "${GREEN}✓ JRE downloaded successfully${NC}"
echo ""

echo -e "${BLUE}Step 3: Extracting JRE...${NC}"
unzip -q /tmp/jre.zip -d /tmp/jre-extract

# Find the JRE directory (it's usually in a subdirectory)
JRE_SOURCE=$(find /tmp/jre-extract -type d -name "jdk-*" -o -name "jre-*" | head -1)
if [ -z "$JRE_SOURCE" ]; then
    # Try to find any directory with bin/java
    JRE_SOURCE=$(find /tmp/jre-extract -type f -name "java.exe" | head -1 | xargs dirname | xargs dirname)
fi

if [ -z "$JRE_SOURCE" ]; then
    echo "Error: Could not find JRE in extracted archive"
    exit 1
fi

# Move JRE to package directory
mv "$JRE_SOURCE" "$JRE_DIR"

echo -e "${GREEN}✓ JRE extracted to package${NC}"
echo ""

echo -e "${BLUE}Step 4: Cleaning up...${NC}"
rm -f /tmp/jre.zip
rm -rf /tmp/jre-extract

echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

echo -e "${BLUE}Step 5: Rebuilding portable package with JRE...${NC}"
./build-portable.sh

echo ""
echo "========================================"
echo -e "${GREEN}JRE Bundling Complete!${NC}"
echo "========================================"
echo ""
echo "The portable package now includes:"
echo "  ✓ PosApp application"
echo "  ✓ Bundled Java Runtime"
echo "  ✓ All dependencies"
echo ""
echo "The package is truly portable and will work on any Windows PC!"
echo ""

# Show JRE info
if [ -f "$JRE_DIR/release" ]; then
    echo "JRE Information:"
    grep -E "JAVA_VERSION|OS_NAME|OS_ARCH" "$JRE_DIR/release" || true
fi
