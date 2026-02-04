import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/beneficiary_entity.dart';
import '../entities/transfer_entity.dart';

abstract class TransfersRepository {
  Future<Either<Failure, List<BeneficiaryEntity>>> getBeneficiaries();
  Future<Either<Failure, TransferEntity>> createTransfer({
    required String fromAccountId,
    required String beneficiaryId,
    required double amount,
    required String currency,
    String? description,
  });
  Future<Either<Failure, TransferEntity>> confirmTransfer(String transferId);
  Future<Either<Failure, List<TransferEntity>>> getTransfers();
}
