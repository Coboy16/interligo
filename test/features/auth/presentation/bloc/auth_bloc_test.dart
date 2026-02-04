import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/features/auth/domain/entities/token_entity.dart';
import 'package:interligo/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:interligo/features/auth/domain/usecases/login_usecase.dart';
import 'package:interligo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:interligo/features/auth/presentation/bloc/bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockCheckAuthStatusUseCase extends Mock
    implements CheckAuthStatusUseCase {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = TokenEntity(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    expiresIn: 3600,
  );

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(bloc.state, const AuthInitial());
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          when(
            () => mockLoginUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Right(tToken));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const AuthLoginRequested(email: tEmail, password: tPassword),
        ),
        expect: () => [const AuthLoading(), const AuthAuthenticated()],
        verify: (_) {
          verify(() => mockLoginUseCase(email: tEmail, password: tPassword));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(
            () => mockLoginUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => const Left(AuthFailure('Invalid credentials')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const AuthLoginRequested(email: tEmail, password: tPassword),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError('Invalid credentials'),
        ],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
        build: () {
          when(
            () => mockLogoutUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthLogoutRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
      );
    });

    group('AuthCheckStatusRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user is authenticated',
        build: () {
          when(
            () => mockCheckAuthStatusUseCase(),
          ).thenAnswer((_) async => const Right(true));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [const AuthLoading(), const AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when user is not authenticated',
        build: () {
          when(
            () => mockCheckAuthStatusUseCase(),
          ).thenAnswer((_) async => const Right(false));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthCheckStatusRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
      );
    });
  });
}
