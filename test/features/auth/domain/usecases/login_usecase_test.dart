import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/features/auth/domain/entities/token_entity.dart';
import 'package:interligo/features/auth/domain/repositories/auth_repository.dart';
import 'package:interligo/features/auth/domain/usecases/login_usecase.dart';

// Mock AuthRepository using Mocktail
class MockAuthRepository extends Mock implements AuthRepository {}

// Mock TokenEntity
class MockTokenEntity extends Mock implements TokenEntity {}

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tTokenEntity = MockTokenEntity();

  group('LoginUseCase', () {
    test('should return Right(TokenEntity) when login is successful', () async {
      // Arrange
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => Right(tTokenEntity));

      // Act
      final result = await usecase(email: tEmail, password: tPassword);

      // Assert
      expect(result, Right(tTokenEntity));
      verify(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Left(Failure) when login fails', () async {
      // Arrange
      const tFailure = AuthFailure('Invalid credentials');
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}