import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class LoggerUtil {
  static void logAuthEvent(String event, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final message = _formatData(data);
      dev.log('[$timestamp] AUTH_LOG: $event $message', name: 'Interligo.Auth');
    }
  }

  static String _formatData(Map<String, dynamic>? data) {
    if (data == null) return '';
    final maskedData = Map<String, dynamic>.from(data);

    // Máscara de seguridad para no imprimir PII
    if (maskedData.containsKey('password')) maskedData['password'] = '********';
    if (maskedData.containsKey('access_token'))
      maskedData['access_token'] = 'TOKEN_REDACTED';
    if (maskedData.containsKey('refresh_token'))
      maskedData['refresh_token'] = 'TOKEN_REDACTED';

    return '| Data: $maskedData';
  }
}
