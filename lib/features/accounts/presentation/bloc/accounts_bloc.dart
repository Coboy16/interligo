import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_account_by_id_usecase.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final GetAccountsUseCase getAccountsUseCase;
  final GetAccountByIdUseCase getAccountByIdUseCase;

  AccountsBloc({
    required this.getAccountsUseCase,
    required this.getAccountByIdUseCase,
  }) : super(const AccountsInitial()) {
    on<AccountsLoadRequested>(_onLoadAccounts);
    on<AccountsRefreshRequested>(_onRefreshAccounts);
    on<AccountDetailRequested>(_onLoadAccountDetail);
  }

  Future<void> _onLoadAccounts(
    AccountsLoadRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(const AccountsLoading());

    final result = await getAccountsUseCase();

    result.fold(
      (failure) => emit(AccountsError(failure.message)),
      (accounts) => emit(AccountsLoaded(accounts: accounts)),
    );
  }

  Future<void> _onRefreshAccounts(
    AccountsRefreshRequested event,
    Emitter<AccountsState> emit,
  ) async {
    final result = await getAccountsUseCase();

    result.fold(
      (failure) => emit(AccountsError(failure.message)),
      (accounts) => emit(AccountsLoaded(accounts: accounts)),
    );
  }

  Future<void> _onLoadAccountDetail(
    AccountDetailRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(const AccountDetailLoading());

    final result = await getAccountByIdUseCase(event.accountId);

    result.fold(
      (failure) => emit(AccountDetailError(failure.message)),
      (account) => emit(AccountDetailLoaded(account: account)),
    );
  }
}
