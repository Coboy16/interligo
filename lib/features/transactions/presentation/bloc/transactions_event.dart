import 'package:equatable/equatable.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

class TransactionsLoadRequested extends TransactionsEvent {
  final String accountId;

  const TransactionsLoadRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}

class TransactionsLoadMoreRequested extends TransactionsEvent {
  final String accountId;

  const TransactionsLoadMoreRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}

class TransactionsRefreshRequested extends TransactionsEvent {
  final String accountId;

  const TransactionsRefreshRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}
