import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.accountId,
    required super.date,
    required super.amount,
    required super.description,
    required super.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      accountId: json['account_id'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      type: (json['type'] as String) == 'income'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'type': type == TransactionType.income ? 'income' : 'expense',
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      accountId: entity.accountId,
      date: entity.date,
      amount: entity.amount,
      description: entity.description,
      type: entity.type,
    );
  }

  factory TransactionModel.fromTableData(TransactionsTableData data) {
    return TransactionModel(
      id: data.transactionId,
      accountId: data.accountId,
      date: data.date,
      amount: data.amount,
      description: data.description,
      type: data.type == 'income'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }

  TransactionsTableCompanion toTableCompanion() {
    return TransactionsTableCompanion(
      transactionId: Value(id),
      accountId: Value(accountId),
      date: Value(date),
      amount: Value(amount),
      description: Value(description),
      type: Value(type == TransactionType.income ? 'income' : 'expense'),
    );
  }
}

class PaginatedTransactionsModel extends PaginatedTransactions {
  const PaginatedTransactionsModel({
    required List<TransactionModel> super.transactions,
    required super.currentPage,
    required super.totalPages,
    required super.perPage,
  });

  factory PaginatedTransactionsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final pagination = json['pagination'] as Map<String, dynamic>;

    return PaginatedTransactionsModel(
      transactions: data
          .map(
            (item) => TransactionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      currentPage: pagination['current_page'] as int,
      totalPages: pagination['total_pages'] as int,
      perPage: pagination['per_page'] as int,
    );
  }
}
