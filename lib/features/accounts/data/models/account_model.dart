import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.id,
    super.userId,
    required super.alias,
    required super.accountNumber,
    required super.currency,
    required super.availableBalance,
    required super.ledgerBalance,
    required super.type,
    required super.status,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      alias: json['alias'] as String,
      accountNumber: json['account_number'] as String,
      currency: json['currency'] as String,
      availableBalance: (json['available_balance'] as num).toDouble(),
      ledgerBalance: (json['ledger_balance'] as num).toDouble(),
      type: _parseAccountType(json['type'] as String),
      status: _parseAccountStatus(json['status'] as String),
    );
  }

  static AccountType _parseAccountType(String type) {
    switch (type.toUpperCase()) {
      case 'SAVINGS':
        return AccountType.savings;
      case 'CHECKING':
        return AccountType.checking;
      default:
        return AccountType.savings;
    }
  }

  static AccountStatus _parseAccountStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AccountStatus.active;
      case 'INACTIVE':
        return AccountStatus.inactive;
      default:
        return AccountStatus.active;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'alias': alias,
      'account_number': accountNumber,
      'currency': currency,
      'available_balance': availableBalance,
      'ledger_balance': ledgerBalance,
      'type': type.name.toUpperCase(),
      'status': status.name.toUpperCase(),
    };
  }

  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      userId: entity.userId,
      alias: entity.alias,
      accountNumber: entity.accountNumber,
      currency: entity.currency,
      availableBalance: entity.availableBalance,
      ledgerBalance: entity.ledgerBalance,
      type: entity.type,
      status: entity.status,
    );
  }

  factory AccountModel.fromTableData(AccountsTableData data) {
    return AccountModel(
      id: data.accountId,
      alias: data.alias,
      accountNumber: '', // Not stored in cache
      currency: data.currency,
      availableBalance: data.availableBalance,
      ledgerBalance: data.ledgerBalance,
      type: AccountType.savings, // Default, not stored in cache
      status: AccountStatus.active, // Default, not stored in cache
    );
  }

  AccountsTableCompanion toTableCompanion() {
    return AccountsTableCompanion(
      accountId: Value(id),
      alias: Value(alias),
      currency: Value(currency),
      availableBalance: Value(availableBalance),
      ledgerBalance: Value(ledgerBalance),
    );
  }
}
