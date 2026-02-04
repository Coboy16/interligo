import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class TransactionEntity extends Equatable {
  final String id;
  final String accountId;
  final DateTime date;
  final double amount;
  final String description;
  final TransactionType type;

  const TransactionEntity({
    required this.id,
    required this.accountId,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  @override
  List<Object?> get props => [id, accountId, date, amount, description, type];
}

class PaginatedTransactions extends Equatable {
  final List<TransactionEntity> transactions;
  final int currentPage;
  final int totalPages;
  final int perPage;

  const PaginatedTransactions({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
  });

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [transactions, currentPage, totalPages, perPage];
}
