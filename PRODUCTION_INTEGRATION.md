# Production Backend Integration

This document outlines the integration of the Flutter app with the production backend deployed on Render.

## 🚀 Backend Deployment

The AI Scheduling Backend is successfully deployed and running at:

- **Production URL**: `https://aido-backend.onrender.com`
- **API Base URL**: `https://aido-backend.onrender.com/api/v1`
- **Health Check**: `https://aido-backend.onrender.com/health`

## 🔧 Key Updates Made

### 1. API Configuration

- Updated `ApiConstants` to use production URL in release mode
- Added environment-specific configuration (debug vs release)
- Configured proper API versioning (`/api/v1`)

### 2. Authentication System

- Implemented JWT token-based authentication
- Added secure storage for tokens using `flutter_secure_storage`
- Created `SecureStorageService` for token management
- Added automatic token injection via `AuthInterceptor`

### 3. Response Model Updates

- Updated all response models to match backend structure
- Added proper data wrapping (`success`, `data`, `error` fields)
- Implemented consistent error handling

### 4. API Client Updates

- Updated endpoint parameters to match backend API
- Added proper error handling for API responses
- Implemented automatic authentication header injection

## 📱 API Endpoints

### Authentication

- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/profile` - Get user profile (requires auth)

### Schedules

- `POST /api/v1/schedules` - Create schedule from prompt
- `GET /api/v1/schedules` - Get all schedules (requires auth)
- `GET /api/v1/schedules/{id}` - Get specific schedule (requires auth)
- `PUT /api/v1/schedules/{id}` - Update schedule (requires auth)
- `DELETE /api/v1/schedules/{id}` - Delete schedule (requires auth)
- `GET /api/v1/schedules/date-range` - Get by date range (requires auth)
- `GET /api/v1/schedules/type/{type}` - Get by type (requires auth)

### System

- `GET /health` - Health check (no auth required)

## 🔐 Authentication Flow

1. **Registration**: User creates account with email, password, first name, last name
2. **Login**: User authenticates with email and password
3. **Token Storage**: JWT token is securely stored using `flutter_secure_storage`
4. **Automatic Auth**: All subsequent requests automatically include the token
5. **Token Refresh**: App handles token expiration and logout

## 🛡️ Security Features

- **Secure Token Storage**: JWT tokens stored in secure storage
- **Automatic Header Injection**: Auth interceptor adds tokens to requests
- **Error Handling**: Proper handling of 401/403 responses
- **Token Cleanup**: Automatic token removal on authentication failures

## 🔄 Environment Configuration

The app automatically switches between environments:

- **Debug Mode**: Uses `http://localhost:3000/api/v1` (for development)
- **Release Mode**: Uses `https://aido-backend.onrender.com/api/v1` (for production)

## 📊 Response Format

All API responses follow this structure:

```json
{
  "success": boolean,
  "data": object | array | null,
  "message": string | null,
  "error": string | null
}
```

## 🧪 Testing the Integration

### 1. Health Check

```bash
curl https://aido-backend.onrender.com/health
```

### 2. User Registration

```bash
curl -X POST https://aido-backend.onrender.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123",
    "firstName": "John",
    "lastName": "Doe"
  }'
```

### 3. User Login

```bash
curl -X POST https://aido-backend.onrender.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123"
  }'
```

### 4. Create Schedule

```bash
curl -X POST https://aido-backend.onrender.com/api/v1/schedules \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "prompt": "Schedule a meeting tomorrow at 2 PM"
  }'
```

## 🚀 Deployment Status

✅ **Backend**: Successfully deployed on Render
✅ **Database**: MongoDB Atlas connected and operational
✅ **Authentication**: JWT system fully functional
✅ **API Endpoints**: All endpoints tested and working
✅ **Flutter Integration**: Updated to use production backend

## 📝 Next Steps

1. **Testing**: Test all features with production backend
2. **Error Handling**: Verify error scenarios work correctly
3. **Performance**: Monitor API response times
4. **Monitoring**: Set up error tracking and analytics
5. **User Testing**: Conduct user acceptance testing

## 🔧 Troubleshooting

### Common Issues

1. **404 Errors**: Ensure using `/api/v1` prefix in URLs
2. **401 Errors**: Check token validity and expiration
3. **Network Errors**: Verify internet connectivity
4. **CORS Issues**: Backend configured for Flutter app origins

### Debug Mode

- Use `flutter run` for development with local backend
- Check console logs for API requests/responses
- Verify token storage and injection

### Production Mode

- Use `flutter build` for production builds
- Test with production backend
- Monitor error logs and performance

---

**Last Updated**: July 28, 2025
**Version**: 2.1.1
**Status**: ✅ Production Ready
