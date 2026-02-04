import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String alias;
  final String currency;
  final double availableBalance;
  final double ledgerBalance;

  const AccountEntity({
    required this.id,
    required this.alias,
    required this.currency,
    required this.availableBalance,
    required this.ledgerBalance,
  });

  double get pendingBalance => ledgerBalance - availableBalance;

  @override
  List<Object?> get props => [
    id,
    alias,
    currency,
    availableBalance,
    ledgerBalance,
  ];
}
