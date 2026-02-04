import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/features/auth/domain/entities/token_entity.dart';
import 'package:interligo/features/auth/domain/repositories/auth_repository.dart';
import 'package:interligo/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = TokenEntity(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    expiresIn: 3600,
  );

  group('LoginUseCase', () {
    test('should get token from repository when login is successful', () async {
      // Arrange
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tToken));

      // Act
      final result = await useCase(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Right(tToken));
      verify(() => mockRepository.login(email: tEmail, password: tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when login fails', () async {
      // Arrange
      const tFailure = AuthFailure('Invalid credentials');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.login(email: tEmail, password: tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet connection',
        () async {
      // Arrange
      const tFailure = NetworkFailure('No internet connection');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(tFailure));
    });
  });
}
