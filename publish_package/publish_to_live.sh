#!/bin/bash

# Publish Package to Production PyPI
# This script publishes your package to the live PyPI (production)

echo "🚀 Publishing Cosmos Auth Package to Production PyPI"
echo "====================================================="
echo ""

# Check if venv is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "⚠️  Virtual environment not activated!"
    echo "   Please activate venv first:"
    echo "   source venv/bin/activate"
    echo ""
    echo "   Or create one:"
    echo "   python3.13 -m venv venv"
    echo "   source venv/bin/activate"
    exit 1
fi

# Check if .pypirc exists
if [ ! -f ~/.pypirc ]; then
    echo "❌ Error: ~/.pypirc not found!"
    echo ""
    echo "Please set up your PyPI credentials:"
    echo "  1. Copy .pypirc.example to your home directory:"
    echo "     cp .pypirc.example ~/.pypirc"
    echo "  2. Edit ~/.pypirc and add your PyPI credentials"
    echo "  3. Get your token from: https://pypi.org/manage/account/"
    echo ""
    exit 1
fi

# Use venv Python
PYTHON="$VIRTUAL_ENV/bin/python"
echo "✅ Using Python: $PYTHON"
$PYTHON --version
echo ""

# Install/upgrade build tools
echo "1️⃣  Installing/upgrading build tools..."
$PYTHON -m pip install --upgrade pip setuptools wheel build twine
echo ""

# Clean old builds
echo "2️⃣  Cleaning old builds..."
rm -rf dist/ build/ *.egg-info/ 2>/dev/null
echo "   ✅ Cleaned"
echo ""

# Build package
echo "3️⃣  Building package..."
$PYTHON -m build
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "   ✅ Built successfully"
echo ""

# Check if wheel exists
WHEEL=$(ls dist/*.whl 2>/dev/null | head -1)
if [ -z "$WHEEL" ]; then
    echo "❌ No wheel file found!"
    exit 1
fi

echo "   📦 Wheel: $WHEEL"
echo "   📦 Source: $(ls dist/*.tar.gz 2>/dev/null | head -1)"
echo ""

# Get package name from setup.py
PACKAGE_NAME=$(grep -E "^\s*name\s*=" setup.py | sed "s/.*name\s*=\s*[\"']\(.*\)[\"'].*/\1/")
echo "   📋 Package: $PACKAGE_NAME"
echo ""

# Confirm before publishing
echo "⚠️  WARNING: You are about to publish to PRODUCTION PyPI!"
echo "   Package: $PACKAGE_NAME"
echo "   This will be publicly available to everyone!"
echo ""
read -p "   Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "   ❌ Publishing cancelled"
    exit 0
fi

echo ""

# Upload to PyPI
echo "4️⃣  Uploading to PyPI (production)..."
$PYTHON -m twine upload dist/*
if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Upload failed!"
    echo ""
    echo "Common issues:"
    echo "  - Check your ~/.pypirc credentials"
    echo "  - Verify token at: https://pypi.org/manage/account/"
    echo "  - Make sure package name is unique on PyPI"
    echo "  - Check if version number is already published"
    exit 1
fi

echo ""
echo "✅ Successfully published to PyPI!"
echo ""
echo "🎉 Your package is now live!"
echo ""
echo "📦 Package Information:"
echo "   Name: $PACKAGE_NAME"
echo "   URL: https://pypi.org/project/$PACKAGE_NAME/"
echo ""
echo "📥 Installation:"
echo "   pip install $PACKAGE_NAME"
echo ""
echo "✅ Done!"


