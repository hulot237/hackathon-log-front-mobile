# LogTracker - Mobile Log Management App

A modern Flutter application for log management with a clean UI and intuitive UX. This app allows users to track, filter, and analyze application logs on mobile devices.

## Features

- **Splash Screen**: Animated logo and loading indicator
- **Onboarding**: Introduction to app features with smooth animations
- **Authentication**: Login screen with email/password and Google sign-in options
- **Dashboard**: Overview of log statistics with charts and recent logs
- **Log Listing**: Complete list of logs with filtering and search capabilities
- **Log Details**: Detailed view of individual logs with metadata and stacktrace
- **Dark Mode Support**: Full support for light and dark themes
- **Responsive Design**: Works on various screen sizes

## Technical Details

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **UI**: Material Design 3
- **Animations**: Flutter Animate for smooth transitions
- **Charts**: FL Chart for data visualization

## Project Structure

```
lib/
├── constants/       # App-wide constants and theme definitions
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── widgets/         # Reusable UI components
├── utils/           # Utility functions
└── main.dart        # App entry point
```

## Getting Started

1. Ensure you have Flutter installed on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Mock Data

The app uses mock data for demonstration purposes. In a real-world scenario, this would be replaced with API calls to a backend service.

## Future Improvements

- Backend integration with real-time log streaming
- Push notifications for critical errors
- Advanced filtering options
- Custom log categories
- Export logs to various formats
- User management and team collaboration features
# hackathon-log-front-mobile
