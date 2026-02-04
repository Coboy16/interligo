import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserLoadRequested extends UserEvent {
  final bool forceRefresh;

  const UserLoadRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class UserRefreshRequested extends UserEvent {
  const UserRefreshRequested();
}

class UserCleared extends UserEvent {
  const UserCleared();
}
