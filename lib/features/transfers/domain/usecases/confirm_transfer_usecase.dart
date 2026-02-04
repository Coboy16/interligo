import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class ConfirmTransferUseCase {
  final TransfersRepository repository;

  ConfirmTransferUseCase(this.repository);

  Future<Either<Failure, TransferEntity>> call(String transferId) {
    return repository.confirmTransfer(transferId);
  }
}
