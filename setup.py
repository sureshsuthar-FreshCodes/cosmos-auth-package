"""
Setup file for Cosmos Auth Package
"""

from setuptools import setup, find_packages

# Read README for long description
try:
    with open("README.md", "r", encoding="utf-8") as fh:
        long_description = fh.read()
except FileNotFoundError:
    long_description = "Azure Cosmos DB authentication and user verification package for Python"

setup(
    name="cosmos-auth-package",  # Package name for PyPI
    version="1.0.0",
    author="Your Company Name",
    author_email="your.email@example.com",
    description="Azure Cosmos DB authentication and user verification package with Flask and FastAPI support",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/sureshsuthar-FreshCodes/cosmos-auth-package",
    packages=find_packages(include=["cosmos_auth_package", "cosmos_auth_package.*"]),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Programming Language :: Python :: 3.13",
    ],
    python_requires=">=3.8",
    install_requires=[
        "azure-cosmos>=4.9.0",
    ],
    extras_require={
        "flask": ["flask>=2.0.0"],
        "fastapi": ["fastapi>=0.100.0"],
        "all": ["flask>=2.0.0", "fastapi>=0.100.0"],
    },
    keywords="cosmos db, azure, authentication, user verification, flask, fastapi, auth",
    project_urls={
        "Bug Reports": "https://github.com/sureshsuthar-FreshCodes/cosmos-auth-package/issues",
        "Source": "https://github.com/sureshsuthar-FreshCodes/cosmos-auth-package",
        "Documentation": "https://github.com/sureshsuthar-FreshCodes/cosmos-auth-package#readme",
    },
)

