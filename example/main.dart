import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:telegram_logger/telegram_logger.dart';

void main() {
  // Initialize TelegramLogger
  TelegramLogger.init(
    botToken: 'YOUR_BOT_TOKEN', // O'zingizning bot tokeningizni qo'ying
    chatId: 'YOUR_CHAT_ID',     // O'zingizning chat ID'ngizni qo'ying
    appName: 'Telegram Logger Example',
  );

  // Global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    // Agar UI overflow xatosi bo'lsa
    if (details.exception.toString().contains('RenderFlex overflowed')) {
      TelegramLogger.sendError(
        errorMessage: "UI Overflow Error: ${details.exception.toString()}",
        includeScreenshot: true,
      );
    } else {
      // Boshqa xatolar uchun
      TelegramLogger.sendError(
        errorMessage: "Flutter Error: ${details.exception.toString()}",
        includeScreenshot: true,
      );
    }
  };

  // Platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    TelegramLogger.sendError(
      errorMessage: "Platform Error: ${error.toString()}",
      includeScreenshot: false,
    );
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Logger Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram Logger Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Test Telegram Logger Package',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Send Error with Screenshot
            ElevatedButton.icon(
              onPressed: () {
                TelegramLogger.sendError(
                  errorMessage: "Test error message from Flutter app",
                  includeScreenshot: true,
                  context: context,
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error sent to Telegram!')),
                );
              },
              icon: const Icon(Icons.error),
              label: const Text('Send Error with Screenshot'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            
            const SizedBox(height: 16),
            
            // Send Error without Screenshot
            ElevatedButton.icon(
              onPressed: () {
                TelegramLogger.sendError(
                  errorMessage: "Test error without screenshot",
                  includeScreenshot: false,
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error sent to Telegram!')),
                );
              },
              icon: const Icon(Icons.error_outline),
              label: const Text('Send Error without Screenshot'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            
            const SizedBox(height: 16),
            
            // Send Log Message
            ElevatedButton.icon(
              onPressed: () {
                TelegramLogger.sendLog(
                  message: "User clicked test button at ${DateTime.now()}",
                  includeScreenshot: false,
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Log sent to Telegram!')),
                );
              },
              icon: const Icon(Icons.message),
              label: const Text('Send Log Message'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            
            const SizedBox(height: 16),
            
            // Send Custom Template
            ElevatedButton.icon(
              onPressed: () {
                TelegramLogger.sendError(
                  errorMessage: "Custom template test error",
                  customTemplate: (error, time, appName) {
                    return '''
🔥 CUSTOM ERROR REPORT 🔥
━━━━━━━━━━━━━━━━━━━━━━━━━━
📱 App: $appName
🕒 Time: ${time.toLocal()}
🚨 Error: $error
🏷️ Environment: Development
🔧 Version: 1.0.0
━━━━━━━━━━━━━━━━━━━━━━━━━━
                    ''';
                  },
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom error sent!')),
                );
              },
              icon: const Icon(Icons.star),
              label: const Text('Send with Custom Template'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            
            const SizedBox(height: 16),
            
            // Test Overflow Error
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OverflowTestPage()),
                );
              },
              icon: const Icon(Icons.warning),
              label: const Text('Test Overflow Error'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            ),
            
            const SizedBox(height: 32),
            
            Text(
              'Check your Telegram chat to see the messages!',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Test overflow error page
class OverflowTestPage extends StatelessWidget {
  const OverflowTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overflow Test')),
      body: Column(
        children: [
          // Bu yerda overflow xatosi yuz beradi
          Row(
            children: [
              Container(
                width: 1000, // Ekrandan katta
                height: 50,
                color: Colors.red,
                child: const Text(
                  'This will cause overflow error and send to Telegram!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}