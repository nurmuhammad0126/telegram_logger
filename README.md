# telegram_logger 📱➡️📲

[![pub package](https://img.shields.io/pub/v/telegram_logger.svg)](https://pub.dev/packages/telegram_logger)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package for sending error reports and logs to Telegram with optional screenshots. Perfect for debugging and monitoring your Flutter applications in real-time!

## ✨ Features

- 🚨 **Error reporting** - Send crash reports and errors to Telegram
- 📋 **Custom logging** - Send custom log messages
- 📸 **Screenshot support** - Include screenshots with error reports
- 🎨 **Customizable templates** - Create your own message templates
- 🔧 **Easy setup** - Simple configuration with Telegram bot
- 📱 **Cross-platform** - Works on Android, iOS, Web, and Desktop

## 🚀 Getting Started

### 1. Add dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  telegram_logger: ^0.0.1
```

### 2. Create Telegram Bot

#### Step 1: Create a new bot
1. Open Telegram and search for `@BotFather`
2. Start a chat with BotFather
3. Send `/newbot` command
4. Choose a name for your bot (e.g., "MyApp Error Bot")
5. Choose a username for your bot (e.g., "myapp_error_bot")
6. BotFather will give you a **bot token** - save this!

**📺 Video Tutorial:** [How to Create Telegram Bot](https://www.youtube.com/watch?v=UQrcOj63S2o)

#### Step 2: Get your Chat ID
1. Search for `@userinfobot` on Telegram
2. Start a chat with it
3. Send any message
4. The bot will reply with your **Chat ID** - save this!

**📺 Video Tutorial:** [How to Get Telegram Chat ID](https://www.youtube.com/watch?v=KqTRzJJ9WOY)

### 3. Initialize in your app

```dart
import 'package:telegram_logger/telegram_logger.dart';

void main() {
  // Initialize TelegramLogger
  TelegramLogger.init(
    botToken: 'YOUR_BOT_TOKEN',
    chatId: 'YOUR_CHAT_ID',
    appName: 'My Flutter App',
  );

  // Catch Flutter errors automatically
  FlutterError.onError = (FlutterErrorDetails details) {
    TelegramLogger.sendError(
      errorMessage: details.exception.toString(),
      includeScreenshot: true,
    );
  };

  runApp(MyApp());
}
```

## 📖 Usage

### Basic Error Reporting

```dart
try {
  // Your code that might throw an error
  await riskyOperation();
} catch (e) {
  TelegramLogger.sendError(
    errorMessage: e.toString(),
    includeScreenshot: true,
    context: context,
  );
}
```

### Custom Log Messages

```dart
// Send info logs
TelegramLogger.sendLog(
  message: "User logged in successfully",
  includeScreenshot: false,
);

// Send with screenshot
TelegramLogger.sendLog(
  message: "Payment completed",
  includeScreenshot: true,
  context: context,
);
```

### Custom Message Templates

```dart
TelegramLogger.sendError(
  errorMessage: "Database connection failed",
  customTemplate: (error, time, appName) {
    return '''
🔥 CRITICAL ERROR 🔥
App: $appName
Time: ${time.toLocal()}
Error: $error
Environment: Production
''';
  },
);
```

### Advanced Setup with Global Error Handling

```dart
void main() {
  // Initialize
  TelegramLogger.init(
    botToken: 'YOUR_BOT_TOKEN',
    chatId: 'YOUR_CHAT_ID',
    appName: 'My Flutter App',
    screenshotSuccessLog: '✅ Screenshot sent successfully!',
    screenshotFailureLog: '❌ Failed to send screenshot:',
  );

  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    TelegramLogger.sendError(
      errorMessage: details.exception.toString(),
      includeScreenshot: true,
    );
  };

  // Handle other errors
  PlatformDispatcher.instance.onError = (error, stack) {
    TelegramLogger.sendError(
      errorMessage: error.toString(),
      includeScreenshot: false,
    );
    return true;
  };

  runApp(MyApp());
}
```

### Catch UI Overflow Errors

```dart
void main() {
  TelegramLogger.init(
    botToken: 'YOUR_BOT_TOKEN',
    chatId: 'YOUR_CHAT_ID',
    appName: 'My Flutter App',
  );

  // Catch overflow and other UI errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('RenderFlex overflowed')) {
      TelegramLogger.sendError(
        errorMessage: "UI Overflow: ${details.exception.toString()}",
        includeScreenshot: true,
      );
    } else {
      TelegramLogger.sendError(
        errorMessage: details.exception.toString(),
        includeScreenshot: true,
      );
    }
  };

  runApp(MyApp());
}
```

## 🎯 API Reference

### TelegramLogger.init()

Initialize the logger with your bot credentials.

```dart
TelegramLogger.init({
  required String botToken,        // Your Telegram bot token
  required String chatId,          // Your Telegram chat ID
  required String appName,         // Your app name
  String? screenshotSuccessLog,    // Custom success message
  String? screenshotFailureLog,    // Custom failure message
  String? messageSuccessLog,       // Custom success message for text
  String? messageFailureLog,       // Custom failure message for text
});
```

### TelegramLogger.sendError()

Send error reports to Telegram.

```dart
TelegramLogger.sendError({
  required String errorMessage,                           // Error message
  bool includeScreenshot = false,                        // Include screenshot?
  BuildContext? context,                                 // Context for screenshot
  String Function(String, DateTime, String)? customTemplate, // Custom template
});
```

### TelegramLogger.sendLog()

Send custom log messages to Telegram.

```dart
TelegramLogger.sendLog({
  required String message,         // Log message
  bool includeScreenshot = false,  // Include screenshot?
  BuildContext? context,          // Context for screenshot
});
```

## 🎬 Video Tutorials

- **Create Telegram Bot:** [BotFather Tutorial](https://www.youtube.com/watch?v=UQrcOj63S2o)
- **Get Chat ID:** [UserInfoBot Tutorial](https://www.youtube.com/watch?v=KqTRzJJ9WOY)
- **Telegram Bot API:** [Complete Guide](https://www.youtube.com/watch?v=NwBWW8cNCP4)

## 🛡️ Security Notes

- **Never commit your bot token** to version control
- Use environment variables for sensitive data
- Consider using different bots for different environments (dev, staging, prod)

```dart
// Good practice
TelegramLogger.init(
  botToken: const String.fromEnvironment('TELEGRAM_BOT_TOKEN'),
  chatId: const String.fromEnvironment('TELEGRAM_CHAT_ID'),
  appName: 'My App',
);
```

## 📝 Message Templates

### Default Error Template
```
🚨 Error Report
🕒 Time: 2024-07-16 14:30:25
📱 App: My Flutter App
❗ Error: Exception: Database connection failed
```

### Default Log Template
```
📋 Log Message
🕒 Time: 2024-07-16 14:30:25
📱 App: My Flutter App
💬 Message: User logged in successfully
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Support

If you find this package helpful, please give it a ⭐ on [GitHub](https://github.com/nurmuhammad0126/telegram_logger)!

For issues and feature requests, please visit our [GitHub Issues](https://github.com/nurmuhammad0126/telegram_logger/issues).

---

Made with ❤️ by [Nurmuhammad](https://github.com/nurmuhammad0126)