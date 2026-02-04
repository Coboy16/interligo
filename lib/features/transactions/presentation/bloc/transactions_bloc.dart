import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_transactions_usecase.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionsBloc({
    required this.getTransactionsUseCase,
  }) : super(const TransactionsInitial()) {
    on<TransactionsLoadRequested>(_onLoadTransactions);
    on<TransactionsLoadMoreRequested>(_onLoadMoreTransactions);
    on<TransactionsRefreshRequested>(_onRefreshTransactions);
  }

  Future<void> _onLoadTransactions(
    TransactionsLoadRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(const TransactionsLoading());

    final result = await getTransactionsUseCase(
      accountId: event.accountId,
      page: 1,
    );

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (paginatedTransactions) => emit(TransactionsLoaded(
        transactions: paginatedTransactions.transactions,
        currentPage: paginatedTransactions.currentPage,
        totalPages: paginatedTransactions.totalPages,
      )),
    );
  }

  Future<void> _onLoadMoreTransactions(
    TransactionsLoadMoreRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TransactionsLoaded || !currentState.hasNextPage) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getTransactionsUseCase(
      accountId: event.accountId,
      page: currentState.currentPage + 1,
    );

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (paginatedTransactions) => emit(TransactionsLoaded(
        transactions: [
          ...currentState.transactions,
          ...paginatedTransactions.transactions,
        ],
        currentPage: paginatedTransactions.currentPage,
        totalPages: paginatedTransactions.totalPages,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> _onRefreshTransactions(
    TransactionsRefreshRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final result = await getTransactionsUseCase(
      accountId: event.accountId,
      page: 1,
    );

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (paginatedTransactions) => emit(TransactionsLoaded(
        transactions: paginatedTransactions.transactions,
        currentPage: paginatedTransactions.currentPage,
        totalPages: paginatedTransactions.totalPages,
      )),
    );
  }
}
