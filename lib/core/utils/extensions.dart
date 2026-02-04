import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  String get maskAccountNumber {
    if (length < 4) return this;
    return '****${substring(length - 4)}';
  }

  String get maskCardNumber {
    if (length < 4) return this;
    return '**** **** **** ${substring(length - 4)}';
  }
}

extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormat('dd MMM yyyy').format(this);
  String get formattedDateTime => DateFormat('dd MMM yyyy, HH:mm').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);
  String get iso8601 => toIso8601String();

  String get relativeDate {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'es').format(this).capitalize;
    } else {
      return formattedDate;
    }
  }
}

extension DoubleExtensions on double {
  String toCurrency(String currency) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '\u20AC';
      case 'PEN':
        return 'S/';
      default:
        return currency;
    }
  }

  String get compactCurrency {
    if (abs() >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (abs() >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toStringAsFixed(2);
  }
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
}
