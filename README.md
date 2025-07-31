# AIdo Mobile

<div align="center">

![AIdo Mobile](https://img.shields.io/badge/AIdo-Mobile-blue?style=for-the-badge&logo=flutter)
![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**AI-powered scheduling assistant Flutter application**

A modern, feature-rich mobile application that leverages AI to help users create and manage their schedules through natural language prompts.

</div>

## 🚀 Features

### Core Functionality

- **AI-Powered Scheduling**: Create schedules using natural language prompts
- **Smart Schedule Management**: View, edit, and delete schedules with ease
- **User Authentication**: Secure login and registration system
- **Theme Support**: Light and dark mode with Material 3 design
- **Offline Support**: Local storage with sync capabilities
- **Push Notifications**: Local notifications for schedule reminders

### Key Features

- **Natural Language Processing**: "Meeting with John tomorrow at 3 PM" → Automatic schedule creation
- **Multiple Schedule Types**: Meetings, reminders, tasks, and appointments
- **Priority Management**: High, medium, and low priority levels
- **Category Organization**: Organize schedules by categories
- **Participant Management**: Add participants to meetings
- **Location Support**: Add locations to schedules
- **Duration Tracking**: Set and track schedule durations

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **feature-based** structure:

```
lib/
├── core/                    # Shared core functionality
│   ├── config/             # Environment configuration
│   ├── constants/          # App constants and themes
│   ├── di/                 # Dependency injection
│   ├── errors/             # Error handling
│   ├── network/            # Network layer
│   ├── usecases/           # Base use case classes
│   └── utils/              # Utility functions
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   ├── home/               # Home screen feature
│   ├── schedule/           # Schedule management feature
│   └── settings/           # Settings feature
└── main.dart              # App entry point
```

### Architecture Layers

1. **Presentation Layer**: UI components, BLoC state management
2. **Domain Layer**: Business logic, entities, use cases, repositories
3. **Data Layer**: Data sources, models, repository implementations

### State Management

- **BLoC Pattern**: Using `flutter_bloc` for state management
- **Event-Driven**: Clear separation of events and states
- **Reactive**: Automatic UI updates based on state changes

## 🛠️ Tech Stack

### Core Dependencies

- **Flutter**: 3.10+ with Dart 3.0+
- **State Management**: `flutter_bloc` + `equatable`
- **Dependency Injection**: `get_it` + `injectable`
- **Network**: `dio` + `retrofit` for API communication
- **Local Storage**: `flutter_secure_storage` + `shared_preferences`
- **Functional Programming**: `dartz` for error handling

### UI & Theming

- **Material 3**: Modern Material Design implementation
- **Google Fonts**: Inter font family
- **Custom Theme**: Gemini-inspired color scheme
- **Responsive Design**: Adaptive layouts for different screen sizes

### Development Tools

- **Code Generation**: `build_runner`, `json_serializable`, `retrofit_generator`
- **Testing**: `mockito`, `bloc_test` for unit and widget testing
- **Linting**: `flutter_lints` for code quality
- **Icons**: `flutter_launcher_icons` for app icons

## 📱 Screenshots

_Screenshots will be added here_

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.10.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Git** for version control

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/aido_mobile.git
   cd aido_mobile
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Environment Setup**

   ```bash
   # Copy environment template
   cp env.example .env

   # Edit .env file with your configuration
   # See Environment Configuration section below
   ```

4. **Generate code**

   ```bash
   # Generate all necessary code files
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**

   ```bash
   # For development
   flutter run

   # For production build
   flutter build apk --release
   ```

### Environment Configuration

Create a `.env` file in the root directory with the following variables:

```env
# Environment Configuration
ENVIRONMENT=development

# API Configuration
API_BASE_URL_DEVELOPMENT=http://localhost:3000/api/v1
API_BASE_URL_PRODUCTION=https://aido-backend.onrender.com/api/v1
API_HEALTH_CHECK_URL=https://aido-backend.onrender.com/health

# API Timeouts (in milliseconds)
API_CONNECT_TIMEOUT=30000
API_RECEIVE_TIMEOUT=30000
API_SEND_TIMEOUT=30000

# App Configuration
APP_NAME=AIdo Mobile
APP_VERSION=1.0.0

# Feature Flags
ENABLE_DEBUG_LOGGING=true
ENABLE_ANALYTICS=false
```

## 🏃‍♂️ Development

### Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── env_config.dart          # Environment configuration
│   ├── constants/
│   │   ├── api_constants.dart       # API endpoints and constants
│   │   ├── app_constants.dart       # App-wide constants
│   │   └── theme_constants.dart     # Theme and styling constants
│   ├── di/
│   │   └── injection_container.dart # Dependency injection setup
│   ├── errors/
│   │   ├── exceptions.dart          # Custom exceptions
│   │   └── failures.dart           # Failure classes
│   ├── network/
│   │   ├── api_client.dart         # API client implementation
│   │   ├── auth_interceptor.dart   # Authentication interceptor
│   │   ├── dio_client.dart         # Dio HTTP client setup
│   │   └── network_info.dart       # Network connectivity checker
│   ├── usecases/
│   │   └── usecase.dart            # Base use case classes
│   └── utils/
│       ├── date_utils.dart         # Date and time utilities
│       ├── notification_utils.dart # Notification utilities
│       ├── secure_storage_service.dart # Secure storage service
│       └── validators.dart         # Input validation utilities
├── features/
│   ├── auth/                       # Authentication feature
│   │   ├── data/                   # Data layer
│   │   │   ├── datasources/        # Data sources
│   │   │   ├── models/             # Data models
│   │   │   └── repositories/       # Repository implementations
│   │   ├── domain/                 # Domain layer
│   │   │   ├── entities/           # Business entities
│   │   │   ├── repositories/       # Repository interfaces
│   │   │   └── usecases/           # Business logic use cases
│   │   └── presentation/           # Presentation layer
│   │       ├── bloc/               # BLoC state management
│   │       ├── pages/              # Screen pages
│   │       └── widgets/            # UI components
│   ├── home/                       # Home feature
│   ├── schedule/                   # Schedule management feature
│   └── settings/                   # Settings feature
└── main.dart                       # App entry point
```

### Code Generation

The project uses code generation for several features. Run these commands when needed:

```bash
# Generate all code files
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter packages pub run build_runner watch

# Generate specific files
flutter packages pub run build_runner build --delete-conflicting-outputs --build-filter="lib/features/**/*.dart"
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart

# Run tests in watch mode
flutter test --watch
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/

# Run linter
flutter analyze --no-fatal-infos
```

## 📦 Building

### Android

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App bundle for Play Store
flutter build appbundle --release
```

### iOS

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

### Web

```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release
```

## 🔧 Configuration

### API Configuration

The app supports multiple environments with different API endpoints:

- **Development**: `http://localhost:3000/api/v1`
- **Production**: `https://aido-backend.onrender.com/api/v1`

### Theme Configuration

The app uses a custom theme system with:

- **Light Theme**: Clean, modern design with white backgrounds
- **Dark Theme**: Dark mode with proper contrast
- **Material 3**: Latest Material Design components
- **Custom Colors**: Gemini-inspired color palette

### Notification Configuration

Local notifications are configured for:

- Schedule reminders
- Meeting notifications
- Task due dates
- Appointment alerts

## 🤝 Contributing

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Development Guidelines

- Follow **Clean Architecture** principles
- Use **BLoC pattern** for state management
- Write **unit tests** for business logic
- Write **widget tests** for UI components
- Follow **Flutter coding standards**
- Use **meaningful commit messages**

### Code Style

- Use **Dart formatting** rules
- Follow **Flutter linting** guidelines
- Use **meaningful variable names**
- Add **documentation** for complex functions
- Keep **functions small and focused**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. **Check the documentation** in this README
2. **Search existing issues** on GitHub
3. **Create a new issue** with detailed information
4. **Contact the development team**

## 🔗 Links

- **Backend API**: [AIdo Backend](https://aido-backend.onrender.com)
- **Documentation**: [Flutter Docs](https://docs.flutter.dev)
- **BLoC Documentation**: [flutter_bloc](https://bloclibrary.dev)

## 📊 Project Status

- ✅ **Core Architecture**: Implemented
- ✅ **Authentication**: Complete
- ✅ **Schedule Management**: Complete
- ✅ **AI Integration**: Complete
- ✅ **Theme System**: Complete
- ✅ **Testing Setup**: Complete
- 🔄 **Performance Optimization**: In Progress
- 🔄 **Additional Features**: Planned

---

<div align="center">

**Built with ❤️ using Flutter**

</div>
