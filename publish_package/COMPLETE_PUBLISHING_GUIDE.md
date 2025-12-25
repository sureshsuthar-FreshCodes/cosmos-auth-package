# 📦 Complete Publishing Guide for Cosmos Auth Package

This guide covers everything you need to know to publish the `cosmos-auth-package` to PyPI.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setup](#setup)
3. [Package Configuration](#package-configuration)
4. [Publishing Process](#publishing-process)
5. [Troubleshooting](#troubleshooting)
6. [Version Management](#version-management)

## 🔧 Prerequisites

### 1. PyPI Account

1. Go to https://pypi.org/account/register/
2. Create an account
3. Verify your email

### 2. API Token

1. Go to https://pypi.org/manage/account/
2. Scroll to "API tokens"
3. Click "Add API token"
4. Give it a name (e.g., "cosmos-auth-package")
5. Set scope to "Entire account" or specific project
6. Copy the token (starts with `pypi-`)

### 3. Virtual Environment

```bash
# Create venv if not exists
python3.13 -m venv venv

# Activate venv
source venv/bin/activate
```

## ⚙️ Setup

### Step 1: Configure PyPI Credentials

```bash
# Copy example file
cp .pypirc.example ~/.pypirc

# Edit the file
nano ~/.pypirc
# or
vim ~/.pypirc
```

Update the file with your token:

```ini
[pypi]
username = __token__
password = pypi-YOUR_ACTUAL_TOKEN_HERE
```

**Important**: 
- Username must be `__token__` for API tokens
- Token must start with `pypi-`
- Never commit this file to git!

### Step 2: Update Package Metadata

Edit `setup.py`:

```python
setup(
    name="cosmos-auth-package",  # ⚠️ Check if available on PyPI!
    version="1.0.0",  # ⚠️ Increment for each release
    author="Your Company Name",  # ⚠️ Your name/company
    author_email="your.email@example.com",  # ⚠️ Your email
    url="https://github.com/yourusername/cosmos-auth-package",  # Optional
    # ... rest of config
)
```

**Check Package Name Availability**:
- Visit: https://pypi.org/project/YOUR-PACKAGE-NAME/
- If 404, name is available
- If exists, choose different name

## 📦 Package Configuration

### Files Structure

```
publish_package/
├── cosmos_auth_package/      # Package source code
│   ├── __init__.py
│   ├── user_verifier.py
│   ├── auth_decorators.py
│   └── schemas.py
├── setup.py                   # Package metadata
├── README.md                   # Package description (shown on PyPI)
├── MANIFEST.in                 # Files to include
├── publish_to_live.sh         # Publishing script
└── .pypirc.example             # Credentials template
```

### Key Files Explained

#### `setup.py`
- Package name, version, author
- Dependencies (`install_requires`)
- Optional dependencies (`extras_require`)
- Python version requirements

#### `README.md`
- Shown on PyPI package page
- Should include installation, usage examples
- Supports Markdown

#### `MANIFEST.in`
- Specifies non-Python files to include
- Ensures `README.md` is included

## 🚀 Publishing Process

### Method 1: Using the Script (Recommended)

```bash
# 1. Navigate to publish folder
cd publish_package

# 2. Activate venv
source ../venv/bin/activate

# 3. Run publish script
bash publish_to_live.sh
```

The script will:
1. Check venv is activated
2. Check `.pypirc` exists
3. Install/upgrade build tools
4. Clean old builds
5. Build package (wheel + source)
6. Ask for confirmation
7. Upload to PyPI

### Method 2: Manual Steps

```bash
# 1. Install build tools
pip install --upgrade build twine

# 2. Clean old builds
rm -rf dist/ build/ *.egg-info/

# 3. Build package
python -m build

# 4. Upload to PyPI
python -m twine upload dist/*
```

## 🔍 Troubleshooting

### Error: 403 Forbidden

**Cause**: Authentication issue

**Solutions**:
1. Check `~/.pypirc` exists and is correct
2. Verify username is `__token__` (not your PyPI username)
3. Verify token starts with `pypi-`
4. Check token hasn't expired
5. Regenerate token if needed

### Error: 400 Bad Request - "File already exists"

**Cause**: Version number already published

**Solution**: Increment version in `setup.py`:
```python
version="1.0.1",  # Was 1.0.0
```

### Error: 400 Bad Request - "Invalid package name"

**Cause**: Package name doesn't meet PyPI requirements

**Requirements**:
- Lowercase letters, numbers, hyphens, underscores
- Must start with a letter
- Cannot be a reserved name

**Solution**: Choose a different name

### Error: ModuleNotFoundError during build

**Cause**: Missing dependencies

**Solution**: Install build tools
```bash
pip install --upgrade setuptools wheel build twine
```

## 📈 Version Management

### Semantic Versioning

Use format: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

Examples:
- `1.0.0` → `1.0.1` (bug fix)
- `1.0.0` → `1.1.0` (new feature)
- `1.0.0` → `2.0.0` (breaking change)

### Updating Version

1. Edit `setup.py`:
   ```python
   version="1.0.1",  # Increment here
   ```

2. Edit `cosmos_auth_package/__init__.py`:
   ```python
   __version__ = "1.0.1"  # Keep in sync
   ```

3. Rebuild and publish

### Version Cannot Be Reused

⚠️ **Important**: PyPI doesn't allow reusing version numbers, even if you delete the package!

If you need to fix a release:
- Increment version number
- Publish new version
- Mark old version as deprecated (if needed)

## ✅ Post-Publishing

### 1. Verify Publication

Visit: https://pypi.org/project/YOUR-PACKAGE-NAME/

### 2. Test Installation

```bash
# Create new virtual environment
python3.13 -m venv test_env
source test_env/bin/activate

# Install from PyPI
pip install YOUR-PACKAGE-NAME

# Test import
python -c "from cosmos_auth_package import UserVerifier; print('✅ Works!')"
```

### 3. Update Documentation

- Update GitHub README with PyPI link
- Add installation instructions
- Update changelog

## 🔗 Useful Commands

```bash
# Check package info
pip show YOUR-PACKAGE-NAME

# Uninstall package
pip uninstall YOUR-PACKAGE-NAME

# Install specific version
pip install YOUR-PACKAGE-NAME==1.0.0

# Upgrade package
pip install --upgrade YOUR-PACKAGE-NAME
```

## 📚 Additional Resources

- **PyPI Documentation**: https://packaging.python.org/
- **Setuptools Docs**: https://setuptools.pypa.io/
- **Twine Docs**: https://twine.readthedocs.io/
- **Semantic Versioning**: https://semver.org/

## 🎉 Success!

Once published, your package will be available at:
- **PyPI**: https://pypi.org/project/YOUR-PACKAGE-NAME/
- **Installation**: `pip install YOUR-PACKAGE-NAME`

Users can now install and use your package from anywhere!


