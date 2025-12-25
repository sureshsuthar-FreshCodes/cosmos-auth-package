# 🚀 Publishing Cosmos Auth Package to PyPI

This folder contains everything you need to publish the `cosmos-auth-package` to PyPI.

## 📁 Folder Contents

- `cosmos_auth_package/` - The package source code
- `setup.py` - Package configuration and metadata
- `README.md` - Package documentation (shown on PyPI)
- `MANIFEST.in` - Files to include in distribution
- `publish_to_live.sh` - Script to publish to production PyPI
- `.pypirc.example` - Template for PyPI credentials

## 🎯 Quick Start (3 Steps)

### Step 1: Setup PyPI Credentials

```bash
# Copy the example file to your home directory
cp .pypirc.example ~/.pypirc

# Edit ~/.pypirc and add your PyPI token
# Get token from: https://pypi.org/manage/account/
```

### Step 2: Update Package Metadata

Edit `setup.py` and update:
- `name` - Package name (check if available on PyPI)
- `version` - Version number (increment for each release)
- `author` - Your name/company
- `author_email` - Your email
- `url` - GitHub repository URL (optional)

### Step 3: Publish

```bash
# Make sure you're in this folder
cd publish_package

# Activate virtual environment
source ../venv/bin/activate

# Run the publish script
bash publish_to_live.sh
```

## 📋 Prerequisites

1. **PyPI Account**: Create account at https://pypi.org/account/register/
2. **API Token**: Get token from https://pypi.org/manage/account/
3. **Virtual Environment**: Make sure venv is activated
4. **Build Tools**: Script will install them automatically

## ⚠️ Important Notes

- **Package Name**: Must be unique on PyPI. Check availability first!
- **Version Numbers**: Cannot reuse deleted versions. Always increment!
- **Credentials**: Never commit `~/.pypirc` to git (it's in your home directory)
- **Test First**: Consider testing on TestPyPI first (modify script if needed)

## 🔗 Useful Links

- **PyPI**: https://pypi.org/
- **TestPyPI**: https://test.pypi.org/
- **Package Page**: https://pypi.org/project/YOUR-PACKAGE-NAME/
- **Account Settings**: https://pypi.org/manage/account/

## 📚 Full Documentation

See `COMPLETE_PUBLISHING_GUIDE.md` for detailed instructions.


