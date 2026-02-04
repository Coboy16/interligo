import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interligo/core/error/failures.dart';
import 'package:interligo/features/accounts/domain/entities/account_entity.dart';
import 'package:interligo/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:interligo/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountsRepository extends Mock implements AccountsRepository {}

void main() {
  late GetAccountsUseCase useCase;
  late MockAccountsRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountsRepository();
    useCase = GetAccountsUseCase(mockRepository);
  });

  final tAccounts = [
    const AccountEntity(
      id: 'acc_001',
      alias: 'Cuenta Principal',
      currency: 'USD',
      availableBalance: 15000.50,
      ledgerBalance: 15500.00,
    ),
    const AccountEntity(
      id: 'acc_002',
      alias: 'Cuenta de Ahorros',
      currency: 'USD',
      availableBalance: 8500.25,
      ledgerBalance: 8500.25,
    ),
  ];

  group('GetAccountsUseCase', () {
    test('should get list of accounts from repository', () async {
      // Arrange
      when(() => mockRepository.getAccounts())
          .thenAnswer((_) async => Right(tAccounts));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tAccounts));
      verify(() => mockRepository.getAccounts());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure('Error loading accounts');
      when(() => mockRepository.getAccounts())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
    });

    test('should return CacheFailure when offline and no cached data',
        () async {
      // Arrange
      const tFailure = CacheFailure('No cached accounts');
      when(() => mockRepository.getAccounts())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
    });
  });
}
