import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/beneficiary_entity.dart';
import '../repositories/transfers_repository.dart';

class GetBeneficiariesUseCase {
  final TransfersRepository repository;

  GetBeneficiariesUseCase(this.repository);

  Future<Either<Failure, List<BeneficiaryEntity>>> call() {
    return repository.getBeneficiaries();
  }
}
