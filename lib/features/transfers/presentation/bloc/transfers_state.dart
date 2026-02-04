import 'package:equatable/equatable.dart';

import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/entities/transfer_entity.dart';

abstract class TransfersState extends Equatable {
  const TransfersState();

  @override
  List<Object?> get props => [];
}

class TransfersInitial extends TransfersState {
  const TransfersInitial();
}

// Beneficiaries states
class BeneficiariesLoading extends TransfersState {
  const BeneficiariesLoading();
}

class BeneficiariesLoaded extends TransfersState {
  final List<BeneficiaryEntity> beneficiaries;

  const BeneficiariesLoaded(this.beneficiaries);

  @override
  List<Object?> get props => [beneficiaries];
}

class BeneficiariesError extends TransfersState {
  final String message;

  const BeneficiariesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Transfer states
class TransferCreating extends TransfersState {
  const TransferCreating();
}

class TransferCreated extends TransfersState {
  final TransferEntity transfer;

  const TransferCreated(this.transfer);

  @override
  List<Object?> get props => [transfer];
}

class TransferConfirming extends TransfersState {
  const TransferConfirming();
}

class TransferConfirmed extends TransfersState {
  final TransferEntity transfer;

  const TransferConfirmed(this.transfer);

  @override
  List<Object?> get props => [transfer];
}

class TransferError extends TransfersState {
  final String message;

  const TransferError(this.message);

  @override
  List<Object?> get props => [message];
}
