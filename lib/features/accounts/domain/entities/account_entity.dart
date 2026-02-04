import 'package:equatable/equatable.dart';

enum AccountType { savings, checking }

enum AccountStatus { active, inactive }

class AccountEntity extends Equatable {
  final String id;
  final String? userId;
  final String alias;
  final String accountNumber;
  final String currency;
  final double availableBalance;
  final double ledgerBalance;
  final AccountType type;
  final AccountStatus status;

  const AccountEntity({
    required this.id,
    this.userId,
    required this.alias,
    required this.accountNumber,
    required this.currency,
    required this.availableBalance,
    required this.ledgerBalance,
    required this.type,
    required this.status,
  });

  double get pendingBalance => ledgerBalance - availableBalance;

  bool get isActive => status == AccountStatus.active;

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '**** **** **** ${accountNumber.substring(accountNumber.length - 4)}';
  }

  String get typeDisplayName {
    switch (type) {
      case AccountType.savings:
        return 'Ahorros';
      case AccountType.checking:
        return 'Corriente';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    alias,
    accountNumber,
    currency,
    availableBalance,
    ledgerBalance,
    type,
    status,
  ];
}
