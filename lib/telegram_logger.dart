library telegram_logger;

import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';

/// A Flutter package for sending error reports and logs to Telegram
/// with optional screenshots.
class TelegramLogger {
  static late final String _botToken;
  static late final String _chatId;
  static late final String _appName;

  static String _successLogMessage = '✅ Successfully sent with screenshot!';
  static String _failureLogMessage = '❌ Error sending to Telegram:';
  static String _messageSuccessLog = '✅ Message sent successfully.';
  static String _messageFailureLog = '❌ Error sending message:';

  static final ScreenshotController _screenshotController =
      ScreenshotController();

  /// Initialize the TelegramLogger with required parameters
  /// 
  /// [botToken] - Your Telegram bot token
  /// [chatId] - Your Telegram chat ID
  /// [appName] - Your application name
  /// [screenshotSuccessLog] - Custom success log message for screenshot
  /// [screenshotFailureLog] - Custom failure log message for screenshot
  /// [messageSuccessLog] - Custom success log message for text message
  /// [messageFailureLog] - Custom failure log message for text message
  static void init({
    required String botToken,
    required String chatId,
    required String appName,
    String? screenshotSuccessLog,
    String? screenshotFailureLog,
    String? messageSuccessLog,
    String? messageFailureLog,
  }) {
    _botToken = botToken;
    _chatId = chatId;
    _appName = appName;

    _successLogMessage = screenshotSuccessLog ?? _successLogMessage;
    _failureLogMessage = screenshotFailureLog ?? _failureLogMessage;
    _messageSuccessLog = messageSuccessLog ?? _messageSuccessLog;
    _messageFailureLog = messageFailureLog ?? _messageFailureLog;
  }

  /// Send error report to Telegram
  /// 
  /// [errorMessage] - The error message to send
  /// [includeScreenshot] - Whether to include screenshot or not
  /// [context] - BuildContext for taking screenshot
  /// [customTemplate] - Custom message template function
  static Future<void> sendError({
    required String errorMessage,
    bool includeScreenshot = false,
    BuildContext? context,
    String Function(String error, DateTime time, String appName)?
        customTemplate,
  }) async {
    final now = DateTime.now();

    final String message = customTemplate != null
        ? customTemplate(errorMessage, now, _appName)
        : _defaultTemplate(errorMessage, now, _appName);

    try {
      if (includeScreenshot && context != null) {
        Uint8List? imageBytes = await _screenshotController.captureFromWidget(
          MediaQuery(
            data: MediaQuery.of(context),
            child: MaterialApp(home: Scaffold(body: context.widget)),
          ),
          delay: const Duration(milliseconds: 100),
        );

        if (imageBytes.isNotEmpty) {
          await _sendPhoto(imageBytes, message);
          return;
        }
      }

      await _sendMessage(message);
    } catch (e) {
      log("$_failureLogMessage $e");
    }
  }

  /// Send a custom log message to Telegram
  /// 
  /// [message] - The message to send
  /// [includeScreenshot] - Whether to include screenshot or not
  /// [context] - BuildContext for taking screenshot
  static Future<void> sendLog({
    required String message,
    bool includeScreenshot = false,
    BuildContext? context,
  }) async {
    final now = DateTime.now();
    final String formattedMessage = _defaultLogTemplate(message, now, _appName);

    try {
      if (includeScreenshot && context != null) {
        Uint8List? imageBytes = await _screenshotController.captureFromWidget(
          MediaQuery(
            data: MediaQuery.of(context),
            child: MaterialApp(home: Scaffold(body: context.widget)),
          ),
          delay: const Duration(milliseconds: 100),
        );

        if (imageBytes.isNotEmpty) {
          await _sendPhoto(imageBytes, formattedMessage);
          return;
        }
      }

      await _sendMessage(formattedMessage);
    } catch (e) {
      log("$_failureLogMessage $e");
    }
  }

  static Future<void> _sendPhoto(Uint8List bytes, String caption) async {
    final url = Uri.parse("https://api.telegram.org/bot$_botToken/sendPhoto");
    final request = http.MultipartRequest('POST', url)
      ..fields['chat_id'] = _chatId
      ..fields['caption'] = caption
      ..fields['parse_mode'] = 'Markdown'
      ..files.add(
        http.MultipartFile.fromBytes('photo', bytes, filename: 'screenshot.png'),
      );

    final response = await request.send();
    if (response.statusCode == 200) {
      log(_successLogMessage);
    } else {
      final body = await response.stream.bytesToString();
      log("$_failureLogMessage $body");
    }
  }

  static Future<void> _sendMessage(String text) async {
    final url = Uri.parse("https://api.telegram.org/bot$_botToken/sendMessage");
    final response = await http.post(
      url,
      body: {'chat_id': _chatId, 'text': text, 'parse_mode': 'Markdown'},
    );

    if (response.statusCode == 200) {
      log(_messageSuccessLog);
    } else {
      log("$_messageFailureLog ${response.body}");
    }
  }

  static String _defaultTemplate(String error, DateTime time, String appName) {
    return '''
*🚨 Error Report*
🕒 *Time:* ${time.toLocal()}
📱 *App:* $appName
❗ *Error:* $error
''';
  }

  static String _defaultLogTemplate(String message, DateTime time, String appName) {
    return '''
*📋 Log Message*
🕒 *Time:* ${time.toLocal()}
📱 *App:* $appName
💬 *Message:* $message
''';
  }

  /// Get the screenshot controller for advanced usage
  static ScreenshotController get controller => _screenshotController;
}