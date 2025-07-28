# Environment Configuration Setup

This guide explains how to set up environment configuration for the AIdo Mobile Flutter app.

## 🚀 Quick Setup

1. **Copy the example file**:

   ```bash
   cp .env.example .env
   ```

2. **Update the values** in `.env` file according to your environment

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📁 Environment Files

### `.env` (Production/Development)

This file contains your actual environment configuration. **Never commit this file to version control**.

### `.env.example` (Template)

This file serves as a template showing what environment variables are available. **This file is committed to version control**.

## 🔧 Environment Variables

### Required Variables

| Variable                   | Description           | Example                                    |
| -------------------------- | --------------------- | ------------------------------------------ |
| `ENVIRONMENT`              | Current environment   | `development` or `production`              |
| `API_BASE_URL_DEVELOPMENT` | Development API URL   | `http://localhost:3000/api/v1`             |
| `API_BASE_URL_PRODUCTION`  | Production API URL    | `https://aido-backend.onrender.com/api/v1` |
| `API_HEALTH_CHECK_URL`     | Health check endpoint | `https://aido-backend.onrender.com/health` |

### Optional Variables

| Variable               | Description                 | Default       |
| ---------------------- | --------------------------- | ------------- |
| `API_CONNECT_TIMEOUT`  | API connection timeout (ms) | `30000`       |
| `API_RECEIVE_TIMEOUT`  | API receive timeout (ms)    | `30000`       |
| `API_SEND_TIMEOUT`     | API send timeout (ms)       | `30000`       |
| `APP_NAME`             | Application name            | `AIdo Mobile` |
| `APP_VERSION`          | Application version         | `1.0.0`       |
| `ENABLE_DEBUG_LOGGING` | Enable debug logging        | `true`        |
| `ENABLE_ANALYTICS`     | Enable analytics            | `false`       |

## 🌍 Environment Configuration

The app automatically switches between environments based on the `ENVIRONMENT` variable:

### Development Environment

```env
ENVIRONMENT=development
API_BASE_URL_DEVELOPMENT=http://localhost:3000/api/v1
```

### Production Environment

```env
ENVIRONMENT=production
API_BASE_URL_PRODUCTION=https://aido-backend.onrender.com/api/v1
```

## 🔐 Security Best Practices

1. **Never commit `.env` files** to version control
2. **Use different values** for development and production
3. **Keep sensitive data** out of environment variables
4. **Validate environment** on app startup

## 📱 Usage in Code

The environment configuration is accessed through the `EnvConfig` class:

```dart
import 'package:your_app/core/config/env_config.dart';

// Get API base URL
String apiUrl = EnvConfig.apiBaseUrl;

// Check environment
bool isProduction = EnvConfig.isProduction;

// Get app configuration
String appName = EnvConfig.appName;
```

## 🚨 Troubleshooting

### Missing Environment File

If you get an error about missing environment variables:

1. Make sure `.env` file exists in the project root
2. Check that all required variables are set
3. Verify the file format (no spaces around `=`)

### Environment Validation

The app validates environment configuration on startup. Check the console output for:

```
✅ Environment configuration loaded successfully
Environment: development
API Base URL: http://localhost:3000/api/v1
```

### Common Issues

1. **File not found**: Ensure `.env` is in the project root
2. **Invalid format**: Use `KEY=value` format, no spaces
3. **Missing variables**: Check `.env.example` for required variables
4. **Build issues**: Run `flutter clean` and `flutter pub get`

## 🔄 Environment Switching

To switch between environments, simply change the `ENVIRONMENT` variable:

```env
# For development
ENVIRONMENT=development

# For production
ENVIRONMENT=production
```

The app will automatically use the appropriate API URLs and configuration.

## 📊 Debug Information

You can access debug information about the current environment:

```dart
Map<String, dynamic> debugInfo = EnvConfig.debugInfo;
print(debugInfo);
```

This will show all current environment configuration values.

## 🛡️ Security Notes

- Environment variables are loaded at runtime
- Sensitive data should be stored securely (not in environment variables)
- Use different API keys for different environments
- Regularly rotate production credentials

---

**Remember**: Always keep your `.env` file secure and never commit it to version control!
