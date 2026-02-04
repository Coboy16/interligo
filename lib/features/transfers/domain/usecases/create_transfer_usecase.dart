import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class CreateTransferUseCase {
  final TransfersRepository repository;

  CreateTransferUseCase(this.repository);

  Future<Either<Failure, TransferEntity>> call({
    required String beneficiaryId,
    required String sourceAccountId,
    required double amount,
  }) {
    return repository.createTransfer(
      beneficiaryId: beneficiaryId,
      sourceAccountId: sourceAccountId,
      amount: amount,
    );
  }
}
