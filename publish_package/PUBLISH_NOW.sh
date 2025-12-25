#!/bin/bash

# Quick Publish Script for Cosmos Auth Package
# Run this from the publish_package folder

echo "🚀 Publishing Cosmos Auth Package to PyPI"
echo "=========================================="
echo ""

# Navigate to publish folder
cd "$(dirname "$0")"
echo "📁 Current directory: $(pwd)"
echo ""

# Check if venv is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "⚠️  Activating virtual environment..."
    source ../venv/bin/activate
    if [[ "$VIRTUAL_ENV" == "" ]]; then
        echo "❌ Failed to activate venv!"
        echo "   Please run: source ../venv/bin/activate"
        exit 1
    fi
fi

echo "✅ Using Python: $(which python)"
python --version
echo ""

# Install/upgrade build tools
echo "1️⃣  Installing/upgrading build tools..."
python -m pip install --upgrade pip setuptools wheel build twine -q
echo "   ✅ Done"
echo ""

# Clean old builds
echo "2️⃣  Cleaning old builds..."
rm -rf dist/ build/ *.egg-info/ 2>/dev/null
echo "   ✅ Cleaned"
echo ""

# Build package
echo "3️⃣  Building package..."
python -m build
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
python -m twine upload dist/*
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


