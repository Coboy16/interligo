import 'package:equatable/equatable.dart';

enum TransactionType { credit, debit }

enum TransactionStatus { completed, pending, failed }

class TransactionEntity extends Equatable {
  final String id;
  final String accountId;
  final DateTime date;
  final double amount;
  final String description;
  final TransactionType type;
  final String? category;
  final String? referenceNumber;
  final TransactionStatus status;

  const TransactionEntity({
    required this.id,
    required this.accountId,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
    this.category,
    this.referenceNumber,
    required this.status,
  });

  bool get isCredit => type == TransactionType.credit;
  bool get isDebit => type == TransactionType.debit;

  /// Amount is positive for credits, negative for debits in the API
  double get displayAmount => amount.abs();

  @override
  List<Object?> get props => [
    id,
    accountId,
    date,
    amount,
    description,
    type,
    category,
    referenceNumber,
    status,
  ];
}

class PaginatedTransactions extends Equatable {
  final List<TransactionEntity> transactions;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  const PaginatedTransactions({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [
    transactions,
    currentPage,
    totalPages,
    totalItems,
    itemsPerPage,
  ];
}
