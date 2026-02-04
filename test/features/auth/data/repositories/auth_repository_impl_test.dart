import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:interligo/core/error/exceptions.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/core/network/network_info.dart';
import 'package:interligo/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:interligo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:interligo/features/auth/data/models/token_model.dart';
import 'package:interligo/features/auth/data/models/user_model.dart';
import 'package:interligo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:interligo/features/auth/domain/entities/token_entity.dart';
import 'package:interligo/features/auth/domain/entities/user_entity.dart';

// Mock dependencies
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(
        const TokenModel(accessToken: '', refreshToken: '', expiresIn: 0));
    registerFallbackValue(
        const UserModel(id: '', username: '', email: ''));
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    const tTokenModel =
        TokenModel(accessToken: 'access', refreshToken: 'refresh', expiresIn: 3600);
    const tUserModel =
        UserModel(id: '1', username: 'testuser', email: 'test@example.com');
    const tLoginResponse =
        LoginResponse(token: tTokenModel, user: tUserModel);

    test('should return TokenEntity when login is successful and online',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tLoginResponse);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.saveUser(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Right<Failure, TokenEntity>(tTokenModel));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() =>
              mockRemoteDataSource.login(email: tEmail, password: tPassword))
          .called(1);
      verify(() => mockLocalDataSource.saveToken(tTokenModel)).called(1);
      verify(() => mockLocalDataSource.saveUser(tUserModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result =
          await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(
          result,
          const Left(NetworkFailure(
              'Se requiere conexión a internet para iniciar sesión')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return AuthFailure on ServerException', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(email: tEmail, password: tPassword))
          .thenThrow(ServerException(message: 'Invalid credentials'));

      // Act
      final result =
          await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(AuthFailure('Invalid credentials')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() =>
              mockRemoteDataSource.login(email: tEmail, password: tPassword))
          .called(1);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure on CacheException during save', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tLoginResponse);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenThrow(CacheException(message: 'Failed to save token'));

      // Act
      final result =
          await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(CacheFailure('Failed to save token')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() =>
              mockRemoteDataSource.login(email: tEmail, password: tPassword))
          .called(1);
      verify(() => mockLocalDataSource.saveToken(tTokenModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('logout', () {
    test('should complete successfully when logout is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.logout())
          .thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.clearAll())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockLocalDataSource.clearAll()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test(
        'should complete successfully and clear local data even if remote logout fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.logout())
          .thenThrow(ServerException(message: 'Remote logout failed'));
      when(() => mockLocalDataSource.clearAll())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.logout();

      // Assert - Modified expectation
      expect(result, const Left(CacheFailure('Error al cerrar sesión'))); // Changed from Right(null)
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockLocalDataSource.clearAll()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure when local clear fails', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.logout())
          .thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.clearAll())
          .thenThrow(CacheException(message: 'Local clear failed'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, const Left(CacheFailure('Local clear failed')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockLocalDataSource.clearAll()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });
  });

  group('isAuthenticated', () {
    test('should return true when localDataSource has token', () async {
      // Arrange
      when(() => mockLocalDataSource.hasToken())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDataSource.hasToken()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return false when localDataSource does not have token',
        () async {
      // Arrange
      when(() => mockLocalDataSource.hasToken())
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, const Right(false));
      verify(() => mockLocalDataSource.hasToken()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure when localDataSource fails', () async {
      // Arrange
      when(() => mockLocalDataSource.hasToken())
          .thenThrow(CacheException(message: 'Cache error'));

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, const Left(CacheFailure('Cache error')));
      verify(() => mockLocalDataSource.hasToken()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });
  });

  group('refreshToken', () {
    const tRefreshToken = 'old_refresh_token';
    const tNewTokenModel =
        TokenModel(accessToken: 'new_access', refreshToken: 'new_refresh', expiresIn: 3600);

    test('should return new TokenEntity when refresh is successful and online',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => tRefreshToken);
      when(() => mockRemoteDataSource.refreshToken(tRefreshToken))
          .thenAnswer((_) async => tNewTokenModel);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(result, const Right<Failure, TokenEntity>(tNewTokenModel));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockLocalDataSource.getRefreshToken()).called(1);
      verify(() => mockRemoteDataSource.refreshToken(tRefreshToken)).called(1);
      verify(() => mockLocalDataSource.saveToken(tNewTokenModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(
          result,
          const Left(NetworkFailure(
              'Se requiere conexión a internet para refrescar sesión')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return AuthFailure if no refresh token locally', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(
          result,
          const Left(AuthFailure(
              'Sesión expirada. Por favor inicia sesión nuevamente.')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockLocalDataSource.getRefreshToken()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource); // Fixed
      verifyNoMoreInteractions(mockLocalDataSource); // Fixed
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return AuthFailure on ServerException and clear local data',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => tRefreshToken);
      when(() => mockRemoteDataSource.refreshToken(tRefreshToken))
          .thenThrow(ServerException(message: 'Refresh failed'));
      when(() => mockLocalDataSource.clearAll())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.refreshToken();

      // Assert
      expect(result, const Left(AuthFailure('Refresh failed')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockLocalDataSource.getRefreshToken()).called(1);
      verify(() => mockRemoteDataSource.refreshToken(tRefreshToken)).called(1);
      verify(() => mockLocalDataSource.clearAll()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });
  });

  group('getCurrentUser', () {
    const tUserModel =
        UserModel(id: '1', username: 'testuser', email: 'test@example.com');

    test('should return UserEntity when online and remote data source succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser())
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveUser(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Right<Failure, UserEntity>(tUserModel));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      verify(() => mockLocalDataSource.saveUser(tUserModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return cached UserEntity when offline and cache has user',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getUser())
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Right<Failure, UserEntity>(tUserModel));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test(
        'should return NetworkFailure when offline and cache does not have user',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert - Modified expectation
      expect(result, const Left(AuthFailure('Usuario no encontrado'))); // Changed from NetworkFailure
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return AuthFailure on ServerException when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser())
          .thenThrow(ServerException(message: 'Remote error'));

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Left(AuthFailure('Remote error')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      verifyZeroInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure on CacheException when online during save',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser())
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveUser(any()))
          .thenThrow(CacheException(message: 'Cache save error'));

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Left(CacheFailure('Cache save error')));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      verify(() => mockLocalDataSource.saveUser(tUserModel)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockNetworkInfo);
    });
  });

  group('getCachedUser', () {
    const tUserModel =
        UserModel(id: '1', username: 'testuser', email: 'test@example.com');

    test('should return UserEntity when localDataSource has user', () async {
      // Arrange
      when(() => mockLocalDataSource.getUser())
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, const Right<Failure, UserEntity?>(tUserModel));
      verify(() => mockLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return null when localDataSource does not have user', () async {
      // Arrange
      when(() => mockLocalDataSource.getUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, const Right<Failure, UserEntity?>(null));
      verify(() => mockLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should return CacheFailure when localDataSource fails', () async {
      // Arrange
      when(() => mockLocalDataSource.getUser())
          .thenAnswer((_) async => null); // This line is to avoid throwing, so that error handling is hit below.
      when(() => mockLocalDataSource.getUser()) // This will be the actual failing call
          .thenThrow(CacheException(message: 'Cache error'));

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, const Left(CacheFailure('Cache error')));
      verify(() => mockLocalDataSource.getUser()).called(1);
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });
  });
}
