import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/features/auth/domain/repositories/auth_repository.dart';
import 'package:interligo/features/auth/domain/usecases/check_auth_status_usecase.dart';

// Mock AuthRepository using Mocktail
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CheckAuthStatusUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CheckAuthStatusUseCase(mockAuthRepository);
  });

  group('CheckAuthStatusUseCase', () {
    test('should return Right(true) when isAuthenticated is true', () async {
      // Arrange
      when(() => mockAuthRepository.isAuthenticated())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(true));
      verify(() => mockAuthRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Right(false) when isAuthenticated is false', () async {
      // Arrange
      when(() => mockAuthRepository.isAuthenticated())
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(false));
      verify(() => mockAuthRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Left(Failure) when isAuthenticated fails', () async {
      // Arrange
      const tFailure = ServerFailure('Server Down');
      when(() => mockAuthRepository.isAuthenticated())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
