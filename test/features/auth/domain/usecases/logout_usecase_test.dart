import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/features/auth/domain/repositories/auth_repository.dart';
import 'package:interligo/features/auth/domain/usecases/logout_usecase.dart';

// Mock AuthRepository using Mocktail
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockAuthRepository);
  });

  group('LogoutUseCase', () {
    test('should return Right(null) when logout is successful', () async {
      // Arrange
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Left(Failure) when logout fails', () async {
      // Arrange
      const tFailure = CacheFailure('Failed to clear cache');
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
