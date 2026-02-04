import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class CreateTransferUseCase {
  final TransfersRepository repository;

  CreateTransferUseCase(this.repository);

  Future<Either<Failure, TransferEntity>> call({
    required String fromAccountId,
    required String beneficiaryId,
    required double amount,
    required String currency,
    String? description,
  }) {
    return repository.createTransfer(
      fromAccountId: fromAccountId,
      beneficiaryId: beneficiaryId,
      amount: amount,
      currency: currency,
      description: description,
    );
  }
}
