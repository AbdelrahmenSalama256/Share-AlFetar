import 'dart:convert';
import 'package:flutter/foundation.dart';









//! Print
class Print {

  static const String ansiRESET = '\x1B[0m';
  static const String ansiRED = '\x1B[31m';
  static const String ansiGREEN = '\x1B[32m';
  static const String ansiYELLOW = '\x1B[33m';
  static const String ansiBLUE = '\x1B[34m';
  static const String ansiPURPLE = '\x1B[35m';
  static const String ansiCYAN = '\x1B[36m';
  static const String ansiWHITE = '\x1B[37m';


  static void success(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiGREEN);
    if (kDebugMode) {
      print("✅✅$formattedMessage");
    }
  }


  static void error(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiRED);
    if (kDebugMode) {
      print('❌❌$formattedMessage');
    }
  }


  static void warning(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiYELLOW);
    if (kDebugMode) {
      print('☢️☢️$formattedMessage');
    }
  }


  static void info(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiBLUE);
    if (kDebugMode) {
      print('🔵🔵$formattedMessage');
    }
  }


  static void important(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiPURPLE);
    if (kDebugMode) {
      print('💡 💡$formattedMessage');
    }
  }


  static String _formatMessage(dynamic message, String color) {
    try {
      if (message is Map || message is List) {

        String formattedJson =
            const JsonEncoder.withIndent('  ').convert(message);

        List<String> lines = formattedJson.split('\n');


        return lines.map((line) => '$color$line$ansiRESET').join('\n');
      } else {
        return '$color$message$ansiRESET';
      }
    } catch (e) {

      return '$color$message$ansiRESET';
    }
  }
}
