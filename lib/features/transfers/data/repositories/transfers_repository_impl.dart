import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfers_repository.dart';
import '../datasources/transfers_remote_datasource.dart';

class TransfersRepositoryImpl implements TransfersRepository {
  final TransfersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TransfersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BeneficiaryEntity>>> getBeneficiaries() async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión para ver beneficiarios'),
      );
    }

    try {
      final beneficiaries = await remoteDataSource.getBeneficiaries();
      return Right(beneficiaries);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransferEntity>> createTransfer({
    required String fromAccountId,
    required String beneficiaryId,
    required double amount,
    required String currency,
    String? description,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión para realizar transferencias'),
      );
    }

    try {
      final transfer = await remoteDataSource.createTransfer(
        fromAccountId: fromAccountId,
        beneficiaryId: beneficiaryId,
        amount: amount,
        currency: currency,
        description: description,
      );
      return Right(transfer);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransferEntity>> confirmTransfer(
    String transferId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión para confirmar transferencia'),
      );
    }

    try {
      final transfer = await remoteDataSource.confirmTransfer(transferId);
      return Right(transfer);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TransferEntity>>> getTransfers() async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión para ver transferencias'),
      );
    }

    try {
      final transfers = await remoteDataSource.getTransfers();
      return Right(transfers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
