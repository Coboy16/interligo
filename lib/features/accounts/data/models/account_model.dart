import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.id,
    required super.alias,
    required super.currency,
    required super.availableBalance,
    required super.ledgerBalance,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      alias: json['alias'] as String,
      currency: json['currency'] as String,
      availableBalance: (json['available_balance'] as num).toDouble(),
      ledgerBalance: (json['ledger_balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alias': alias,
      'currency': currency,
      'available_balance': availableBalance,
      'ledger_balance': ledgerBalance,
    };
  }

  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      alias: entity.alias,
      currency: entity.currency,
      availableBalance: entity.availableBalance,
      ledgerBalance: entity.ledgerBalance,
    );
  }

  factory AccountModel.fromTableData(AccountsTableData data) {
    return AccountModel(
      id: data.accountId,
      alias: data.alias,
      currency: data.currency,
      availableBalance: data.availableBalance,
      ledgerBalance: data.ledgerBalance,
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
