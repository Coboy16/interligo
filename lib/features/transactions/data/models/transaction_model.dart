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
    super.category,
    super.referenceNumber,
    required super.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      accountId: json['account_id'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      type: _parseTransactionType(json['type'] as String),
      category: json['category'] as String?,
      referenceNumber: json['reference_number'] as String?,
      status: _parseTransactionStatus(json['status'] as String),
    );
  }

  static TransactionType _parseTransactionType(String type) {
    switch (type.toUpperCase()) {
      case 'CREDIT':
        return TransactionType.credit;
      case 'DEBIT':
        return TransactionType.debit;
      default:
        return TransactionType.debit;
    }
  }

  static TransactionStatus _parseTransactionStatus(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return TransactionStatus.completed;
      case 'PENDING':
        return TransactionStatus.pending;
      case 'FAILED':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.completed;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'type': type == TransactionType.credit ? 'CREDIT' : 'DEBIT',
      'category': category,
      'reference_number': referenceNumber,
      'status': status.name.toUpperCase(),
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
      category: entity.category,
      referenceNumber: entity.referenceNumber,
      status: entity.status,
    );
  }

  factory TransactionModel.fromTableData(TransactionsTableData data) {
    return TransactionModel(
      id: data.transactionId,
      accountId: data.accountId,
      date: data.date,
      amount: data.amount,
      description: data.description,
      type: data.type == 'CREDIT'
          ? TransactionType.credit
          : TransactionType.debit,
      status: TransactionStatus.completed, // Default for cached data
    );
  }

  TransactionsTableCompanion toTableCompanion() {
    return TransactionsTableCompanion(
      transactionId: Value(id),
      accountId: Value(accountId),
      date: Value(date),
      amount: Value(amount),
      description: Value(description),
      type: Value(type == TransactionType.credit ? 'CREDIT' : 'DEBIT'),
    );
  }
}

class PaginatedTransactionsModel extends PaginatedTransactions {
  const PaginatedTransactionsModel({
    required List<TransactionModel> super.transactions,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
    required super.itemsPerPage,
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
      totalItems: pagination['total_items'] as int,
      itemsPerPage: pagination['items_per_page'] as int,
    );
  }
}
