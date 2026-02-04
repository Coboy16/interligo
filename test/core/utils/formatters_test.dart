import 'package:flutter_test/flutter_test.dart';
import 'package:interligo/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    group('currency', () {
      test('should format USD currency correctly', () {
        expect(Formatters.currency(1234.56, currency: 'USD'), '\$1,234.56');
        expect(Formatters.currency(0, currency: 'USD'), '\$0.00');
        expect(Formatters.currency(-500.00, currency: 'USD'), '-\$500.00');
      });

      test('should format EUR currency correctly', () {
        expect(Formatters.currency(1234.56, currency: 'EUR'), '\u20AC1,234.56');
      });

      test('should format PEN currency correctly', () {
        expect(Formatters.currency(1234.56, currency: 'PEN'), 'S/1,234.56');
      });

      test('should use currency code for unknown currencies', () {
        expect(Formatters.currency(100.00, currency: 'GBP'), 'GBP100.00');
      });
    });

    group('date', () {
      test('should format date correctly', () {
        final date = DateTime(2025, 1, 15);
        expect(Formatters.date(date), '15 Jan 2025');
      });
    });

    group('dateTime', () {
      test('should format date and time correctly', () {
        final dateTime = DateTime(2025, 1, 15, 10, 30);
        expect(Formatters.dateTime(dateTime), '15 Jan 2025, 10:30');
      });
    });

    group('cardNumber', () {
      test('should format card number with masked digits', () {
        expect(Formatters.cardNumber('4532'), '**** **** **** 4532');
      });
    });

    group('accountNumber', () {
      test('should mask account number showing only last 4 digits', () {
        expect(Formatters.accountNumber('123456789012'), '****9012');
        expect(Formatters.accountNumber('1234'), '****1234');
      });

      test('should return original for short account numbers', () {
        expect(Formatters.accountNumber('123'), '123');
      });
    });

    group('transactionAmount', () {
      test('should format positive amounts with plus sign', () {
        expect(
          Formatters.transactionAmount(100.00, 'USD'),
          '+\$100.00',
        );
      });

      test('should format negative amounts without extra sign', () {
        expect(
          Formatters.transactionAmount(-50.00, 'USD'),
          '-\$50.00',
        );
      });
    });

    group('percentage', () {
      test('should format percentage correctly', () {
        expect(Formatters.percentage(75.5), '75.5%');
        expect(Formatters.percentage(100.0, decimals: 0), '100%');
      });
    });
  });
}
