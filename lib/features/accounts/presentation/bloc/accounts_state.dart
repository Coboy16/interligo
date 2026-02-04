import 'package:equatable/equatable.dart';

import '../../domain/entities/account_entity.dart';

abstract class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Object?> get props => [];
}

class AccountsInitial extends AccountsState {
  const AccountsInitial();
}

class AccountsLoading extends AccountsState {
  const AccountsLoading();
}

class AccountsLoaded extends AccountsState {
  final List<AccountEntity> accounts;
  final bool isFromCache;

  const AccountsLoaded({
    required this.accounts,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [accounts, isFromCache];
}

class AccountsError extends AccountsState {
  final String message;

  const AccountsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountDetailLoading extends AccountsState {
  const AccountDetailLoading();
}

class AccountDetailLoaded extends AccountsState {
  final AccountEntity account;
  final bool isFromCache;

  const AccountDetailLoaded({
    required this.account,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [account, isFromCache];
}

class AccountDetailError extends AccountsState {
  final String message;

  const AccountDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
