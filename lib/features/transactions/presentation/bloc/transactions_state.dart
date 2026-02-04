import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction_entity.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionEntity> transactions;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final bool isFromCache;

  const TransactionsLoaded({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
    this.isFromCache = false,
  });

  bool get hasNextPage => currentPage < totalPages;

  TransactionsLoaded copyWith({
    List<TransactionEntity>? transactions,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    bool? isFromCache,
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        currentPage,
        totalPages,
        isLoadingMore,
        isFromCache,
      ];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError(this.message);

  @override
  List<Object?> get props => [message];
}
