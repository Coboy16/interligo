import 'package:equatable/equatable.dart';

class BeneficiaryEntity extends Equatable {
  final String id;
  final String? userId;
  final String name;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final String? alias;
  final String? email;

  const BeneficiaryEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    this.alias,
    this.email,
  });

  String get maskedAccountNumber {
    if (accountNumber.length < 4) return accountNumber;
    // API already returns masked, but handle both cases
    if (accountNumber.contains('*')) return accountNumber;
    return '****${accountNumber.substring(accountNumber.length - 4)}';
  }

  String get displayName => alias ?? name;

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    accountNumber,
    bankName,
    bankCode,
    alias,
    email,
  ];
}
