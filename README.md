<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Applytics Flutter

A powerful Flutter analytics package inspired by PostHog. Send analytics events to your own backend with support for batching, session management, and automatic device information collection.

## 🚀 Features

- ✅ Simple and intuitive event tracking
- ✅ Automatic event batching
- ✅ Automatic session management
- ✅ User identification
- ✅ Queue with periodic flushing
- ✅ Debug mode support
- ✅ Network error handling with retry
- ✅ API connection testing
- ✅ Singleton architecture for easy access
- ✅ **Automatic device and app info collection** (included)

## 📦 Installation

Add this dependency to your `pubspec.yaml`:

```yaml
dependencies:
  applytics_flutter: ^0.0.1
```

Then run:

```bash
flutter pub get
```

That's it! Device info packages are already included.

## 🎯 Basic Usage

### 1. Initialization

Initialize Applytics at app startup:

```dart
import 'package:applytics_flutter/applytics_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApplyticsClient.initialize(
    config: AnalyticsConfig(
      apiUrl: 'https://your-supabase-url.supabase.co/functions/v1/track-event',
      apiKey: 'your-project-api-key', // From your projects table
      debug: true, // Enable debug logs
      batchSize: 10, // Send events in batches of 10
      flushIntervalSeconds: 30, // Or every 30 seconds
    ),
  );

  runApp(MyApp());
}
```

### 2. Track Events

```dart
final analytics = ApplyticsClient.instance;

// Simple event
analytics.track('button_clicked');

// Event with properties
analytics.track('product_viewed', properties: {
  'product_id': '123',
  'product_name': 'iPhone 15',
  'category': 'electronics',
  'price': 999.99,
});
```

### 3. Identify a User

```dart
analytics.identify('user_123', userProperties: {
  'name': 'John Doe',
  'email': 'john@example.com',
  'plan': 'premium',
});
```

### 4. Reset (Logout)

```dart
analytics.reset(); // Reset user and session
```

## 🔧 Advanced Configuration

### Configuration Options

```dart
AnalyticsConfig(
  apiUrl: 'https://your-api-url.com/api', // Required
  apiKey: 'your-api-key', // Required
  
  debug: false, // Enable debug logs
  batchSize: 10, // Number of events before auto-send
  flushIntervalSeconds: 30, // Send interval in seconds
  timeoutSeconds: 10, // HTTP request timeout
  enableSessionTracking: true, // Enable session tracking
)
```

### Additional Features

```dart
// Force immediate flush of all pending events
await analytics.flush();

// Get current queue size
int queueSize = analytics.queueSize;

// Get current session ID
String? sessionId = analytics.sessionId;

// Get current user ID
String? userId = analytics.userId;

// Test API connection
bool isConnected = await analytics.testConnection();
```

## 📡 Data Format

Events are sent in the following JSON format:

```json
{
  "events": [
    {
      "name": "button_clicked",
      "properties": {
        "button_name": "submit"
      },
      "created_at": "2025-12-01T10:30:00.000Z",
      "user_id": "user_123",
      "session_id": "1701425400000-1701425400000000"
    }
  ]
}
```

### Expected API Endpoints

Your backend should expose these endpoints:

- `POST /events`)
- `GET /health` - Check API health (optional)

## 🧪 Complete Example

Check the `example/` folder for a complete application demonstrating all features.

## 📝 Best Practices

1. **Initialize once** at application startup
2. **Use consistent event names** (snake_case recommended)
3. **Add relevant properties** for easier analysis
4. **Call `flush()`** before closing the app to avoid losing events
5. **Enable debug mode** during development

## 🔮 Next Steps

To create the web analytics platform:
- Backend API to receive and store events
- Database for storage (PostgreSQL, MongoDB, etc.)
- Web dashboard with charts and statistics
- Data filtering and segmentation

## 📄 License

MIT License

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or pull request.
