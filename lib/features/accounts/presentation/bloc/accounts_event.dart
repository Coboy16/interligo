import 'package:equatable/equatable.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class AccountsLoadRequested extends AccountsEvent {
  const AccountsLoadRequested();
}

class AccountsRefreshRequested extends AccountsEvent {
  const AccountsRefreshRequested();
}

class AccountDetailRequested extends AccountsEvent {
  final String accountId;

  const AccountDetailRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}
