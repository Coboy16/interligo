import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(double amount, {String currency = 'USD'}) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String _getCurrencySymbol(String currency) {
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

  static String date(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  static String dateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, HH:mm').format(date);

  static String time(DateTime date) => DateFormat('HH:mm').format(date);

  static String cardNumber(String lastFour) => '**** **** **** $lastFour';

  static String accountNumber(String number) {
    if (number.length < 4) return number;
    return '****${number.substring(number.length - 4)}';
  }

  static String transactionAmount(double amount, String currency) {
    final sign = amount >= 0 ? '+' : '';
    return '$sign${Formatters.currency(amount, currency: currency)}';
  }

  static String percentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}
