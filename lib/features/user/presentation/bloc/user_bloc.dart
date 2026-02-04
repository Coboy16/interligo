import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UserBloc({required this.getCurrentUserUseCase}) : super(const UserInitial()) {
    on<UserLoadRequested>(_onLoadRequested);
    on<UserRefreshRequested>(_onRefreshRequested);
    on<UserCleared>(_onCleared);
  }

  Future<void> _onLoadRequested(
    UserLoadRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await getCurrentUserUseCase(forceRefresh: event.forceRefresh);

    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onRefreshRequested(
    UserRefreshRequested event,
    Emitter<UserState> emit,
  ) async {
    // Don't show loading state on refresh, keep current user visible
    final result = await getCurrentUserUseCase(forceRefresh: true);

    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  void _onCleared(
    UserCleared event,
    Emitter<UserState> emit,
  ) {
    emit(const UserInitial());
  }
}
