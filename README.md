# Cosmos Auth Package

A Python package for streamlined user authentication and management with Azure Cosmos DB. Provides decorators for Flask and dependencies for FastAPI to easily integrate header-based authentication, user verification, and role-based access control, with optional automatic user creation.

## 📦 Installation

```bash
# Basic installation
pip install cosmos-auth-package

# With Flask support (recommended for Flask projects)
pip install cosmos-auth-package[flask]

# With FastAPI support
pip install cosmos-auth-package[fastapi]

# With both frameworks
pip install cosmos-auth-package[all]
```

## 🎯 Features

- ✅ **Azure Cosmos DB Integration**: Works with your existing Cosmos DB connection
- ✅ **Header-Based Authentication**: Authenticates users via `x-user-email`, `x-user-id`, or `Authorization` headers
- ✅ **User Verification**: Checks if users exist in Cosmos DB
- ✅ **Automatic User Creation**: Optionally creates new users on first access
- ✅ **Role-Based Access Control (RBAC)**: Restrict endpoints based on user roles
- ✅ **Framework Support**: Works with Flask and FastAPI
- ✅ **No Connection Management**: Accepts your existing Cosmos DB container connection

## 🚀 Quick Start

### Step 1: Setup Cosmos DB Connection

In your project, create a Cosmos DB connection (e.g., `cosmos_interface.py`):

```python
from azure.cosmos import CosmosClient
import os

COSMOS_ENDPOINT = os.environ.get('COSMOS_ENDPOINT')
COSMOS_API_KEY = os.environ.get('COSMOS_API_KEY')
COSMOS_DATABASE_NAME = os.environ.get('COSMOS_DATABASE_NAME', 'your-db-name')
COSMOS_USER_CONTAINER_NAME = os.environ.get('COSMOS_USER_CONTAINER_NAME', 'User')

client = CosmosClient(COSMOS_ENDPOINT, COSMOS_API_KEY)
database = client.get_database_client(COSMOS_DATABASE_NAME)
user_container = database.get_container_client(COSMOS_USER_CONTAINER_NAME)
```

### Step 2: Initialize Package

```python
from cosmos_auth_package import UserVerifier
from cosmos_interface import user_container  # Your existing connection

# Initialize with your Cosmos DB container
verifier = UserVerifier(user_container)
```

### Step 3: Use in Flask

```python
from flask import Flask, jsonify, g
from cosmos_auth_package import require_auth, UserRole

app = Flask(__name__)

@app.route('/user/myself', methods=['GET'])
@require_auth(verifier, header_name="x-user-email", auto_create=True)
def get_my_user_info():
    # User is automatically verified and available in g.current_user
    # If auto_create=True and user doesn't exist, it will be created
    user = g.current_user
    return jsonify(user.to_dict())

@app.route('/admin-only', methods=['GET'])
@require_auth(verifier, required_roles=[UserRole.ADMIN])
def admin_dashboard():
    user = g.current_user
    return jsonify({"message": f"Welcome, Admin {user.email}!"})
```

### Step 4: Use in FastAPI

```python
from fastapi import FastAPI, Depends
from cosmos_auth_package import get_current_user, User, UserRole

app = FastAPI()

@app.get('/user/myself')
async def get_my_user_info(
    current_user: User = Depends(get_current_user(verifier, header_name="x-user-email", auto_create=True))
):
    # User is automatically verified and injected as dependency
    return current_user.to_dict()

@app.get('/admin-only')
async def admin_dashboard(
    current_user: User = Depends(get_current_user(verifier, required_roles=[UserRole.ADMIN]))
):
    return {"message": f"Welcome, Admin {current_user.email}!"}
```

## 📚 API Reference

### UserVerifier

The main class for user verification and management.

```python
from cosmos_auth_package import UserVerifier

verifier = UserVerifier(user_container)
```

#### Methods

- `verify_user_exists(user_id: str) -> bool` - Check if user exists
- `get_user(user_id: str) -> Optional[User]` - Get user by ID (email or username)
- `get_user_by_email(email: str) -> Optional[User]` - Get user by email
- `get_user_by_username(username: str) -> Optional[User]` - Get user by username
- `create_user(email, username, role, display_name) -> User` - Create new user
- `get_or_create_user(email, username, role, display_name) -> User` - Get or create user
- `verify_user_role(user_id, required_roles) -> bool` - Check if user has required role
- `update_user_role(user_id, new_role) -> bool` - Update user role

### Flask Decorator: `require_auth`

```python
@require_auth(
    verifier,                    # UserVerifier instance (required)
    header_name="x-user-email",  # Header name to check (default: "x-user-email")
    required_roles=None,         # List of required roles (optional)
    auto_create=False            # Auto-create user if doesn't exist (default: False)
)
```

**Usage:**
```python
@app.route('/protected')
@require_auth(verifier)
def protected_route():
    user = g.current_user  # User object available here
    return jsonify({"message": "Access granted"})
```

**After authentication, user info is available in Flask's `g` object:**
- `g.current_user` - User object
- `g.user_id` - User ID
- `g.user_email` - User email
- `g.user_role` - User role

### FastAPI Dependency: `get_current_user`

```python
current_user: User = Depends(get_current_user(
    verifier,                    # UserVerifier instance (required)
    header_name="x-user-email",  # Header name to check (default: "x-user-email")
    required_roles=None,         # List of required roles (optional)
    auto_create=False            # Auto-create user if doesn't exist (default: False)
))
```

**Usage:**
```python
@app.get("/protected")
async def protected_route(
    current_user: User = Depends(get_current_user(verifier))
):
    return {"message": f"Hello {current_user.email}"}
```

### User Model

```python
from cosmos_auth_package import User, UserRole

# User object structure
user.id              # Cosmos DB item ID (format: "user_{user_id}")
user.type            # Always "user"
user.user_id         # Unique identifier (usually email)
user.email           # User email
user.username        # Username
user.role            # User role (UserRole enum value)
user.display_name    # Display name
user.is_active       # Active status
user.agents          # List of agent IDs

# Convert to dictionary
user_dict = user.to_dict()
```

### UserRole Enum

```python
from cosmos_auth_package import UserRole

UserRole.USER        # "user"
UserRole.ADMIN       # "admin"
UserRole.MODERATOR   # "moderator"
UserRole.VIEWER      # "viewer"
```

## 🔧 How It Works

### Connection Flow

1. **Your Project Creates Connection**: You create the Cosmos DB connection in your project
2. **Package Receives Connection**: The package accepts your existing `ContainerProxy` object
3. **Package Uses Connection**: The package uses your connection to verify users

```python
# In your project (cosmos_interface.py)
client = CosmosClient(COSMOS_ENDPOINT, COSMOS_API_KEY)
database = client.get_database_client(COSMOS_DATABASE_NAME)
user_container = database.get_container_client("User")  # ← Connection created here

# In your routes (routes/users.py)
from cosmos_auth_package import UserVerifier
from cosmos_interface import user_container  # ← Import your connection

verifier = UserVerifier(user_container)  # ← Package receives connected object
```

### Authentication Flow

1. **Request Arrives**: API request with header (e.g., `x-user-email: user@example.com`)
2. **Decorator Intercepts**: `@require_auth` decorator intercepts the request
3. **User Lookup**: Package queries Cosmos DB for the user
4. **User Creation** (if `auto_create=True`): If user doesn't exist, creates new user
5. **Role Check** (if `required_roles` specified): Verifies user has required role
6. **Request Continues**: User info attached to request context (`g.current_user`)

## 📋 Integration Guide

### Files Modified in Your Project

When integrating this package into your project, you need to modify the following files:

#### 1. `requirements.txt`

**Added:**
```txt
cosmos-auth-package[flask]>=1.0.0
```

**Location:** After `azure-cosmos==4.9.0`

**Example:**
```txt
azure-cosmos==4.9.0
cosmos-auth-package[flask]>=1.0.0
azure-identity==1.23.0
```

#### 2. `routes/users.py`

**Changes:**
- **Added imports:**
  ```python
  from cosmos_auth_package import UserVerifier, require_auth
  from cosmos_interface import user_container
  ```

- **Initialized verifier:**
  ```python
  verifier = UserVerifier(user_container)
  ```

- **Updated route decorator:**
  ```python
  @users_bp.route('/user/myself', methods=['GET'])
  @require_auth(verifier, header_name="x-user-email", auto_create=True)
  def user_get_me_route() -> Response:
      user = g.current_user
      user_dict = user.to_dict()
      return jsonify(user_dict)
  ```

**Before:**
```python
# Old custom @authorized decorator
@authorized()
def user_get_me_route():
    # Manual user lookup code
    ...
```

**After:**
```python
# New @require_auth decorator from package
@require_auth(verifier, header_name="x-user-email", auto_create=True)
def user_get_me_route():
    user = g.current_user  # User already verified and available
    return jsonify(user.to_dict())
```

#### 3. `app.py` (Optional - if you have routes here)

If you have routes in `app.py` that need authentication, you can use the same pattern:

```python
from cosmos_auth_package import UserVerifier, require_auth
from cosmos_interface import user_container

verifier = UserVerifier(user_container)

@app.route('/openai_finalytix', methods=['POST'])
@require_auth(verifier)
def openai_query_finalytix_route():
    user = g.current_user
    # Your route logic here
    ...
```

### No Changes Required

- ✅ `cosmos_interface.py` - No changes needed, package uses your existing connection
- ✅ Database schema - Package works with your existing user container structure
- ✅ Other routes - Only modify routes that need authentication

## 🧪 Testing

### Local Testing

Create a test file `test_local.py`:

```python
from cosmos_auth_package import UserVerifier
from cosmos_interface import user_container

verifier = UserVerifier(user_container)

# Test user verification
user = verifier.get_user("test@example.com")
print(f"User found: {user is not None}")
```

### API Testing

Test the authenticated endpoint:

```bash
# Test with user email header
curl -X GET http://localhost:8000/user/myself \
  -H "x-user-email: test@example.com"

# Test with missing header (should return 401)
curl -X GET http://localhost:8000/user/myself
```

## 📦 Package Structure

```
cosmos_auth_package/
├── cosmos_auth_package/
│   ├── __init__.py              # Package initialization and exports
│   ├── user_verifier.py         # User verification and management
│   ├── auth_decorators.py       # Flask and FastAPI decorators
│   └── schemas.py               # User and UserRole models
├── setup.py                     # Package configuration
├── README.md                    # This file
├── MANIFEST.in                  # Files to include in distribution
└── test_local.py                # Local testing script
```

## 🔗 Links

- **PyPI Package**: https://pypi.org/project/cosmos-auth-package/
- **Installation**: `pip install cosmos-auth-package[flask]`
- **Version**: 1.0.0

## 📄 License

MIT License

## 👤 Author

Your Company Name

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 Changelog

### Version 1.0.0
- Initial release
- Flask decorator support
- FastAPI dependency support
- User verification and management
- Role-based access control
- Automatic user creation
- Header-based authentication

## 💡 Use Cases

- API authentication with Cosmos DB
- User verification in microservices
- Role-based access control
- Auto-user creation for new users
- Header-based authentication (API Gateway integration)
- Flask and FastAPI applications

## ❓ FAQ

### Q: Do I need to create a new Cosmos DB connection in the package?

**A:** No! The package accepts your existing Cosmos DB connection. You create the connection in your project and pass the `ContainerProxy` object to the package.

### Q: Can I use this with my existing user container structure?

**A:** Yes! The package works with your existing Cosmos DB user container. It expects users to have fields like `id`, `user_id`, `email`, `username`, `role`, etc.

### Q: What happens if a user doesn't exist?

**A:** If `auto_create=True`, the package will automatically create a new user in Cosmos DB. If `auto_create=False`, it will return a 401 Unauthorized error.

### Q: Can I use this with both Flask and FastAPI?

**A:** Yes! The package supports both frameworks. Install with `pip install cosmos-auth-package[all]` to get both Flask and FastAPI support.

### Q: How do I update user roles?

**A:** Use the `UserVerifier.update_user_role()` method:
```python
verifier.update_user_role("user@example.com", "admin")
```

---

**Made with ❤️ for Azure Cosmos DB and Python developers**
