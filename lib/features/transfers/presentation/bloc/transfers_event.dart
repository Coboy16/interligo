import 'package:equatable/equatable.dart';

abstract class TransfersEvent extends Equatable {
  const TransfersEvent();

  @override
  List<Object?> get props => [];
}

class BeneficiariesLoadRequested extends TransfersEvent {
  const BeneficiariesLoadRequested();
}

class CreateTransferRequested extends TransfersEvent {
  final String beneficiaryId;
  final String sourceAccountId;
  final double amount;

  const CreateTransferRequested({
    required this.beneficiaryId,
    required this.sourceAccountId,
    required this.amount,
  });

  @override
  List<Object?> get props => [beneficiaryId, sourceAccountId, amount];
}

class ConfirmTransferRequested extends TransfersEvent {
  final String transferId;

  const ConfirmTransferRequested(this.transferId);

  @override
  List<Object?> get props => [transferId];
}

class TransferReset extends TransfersEvent {
  const TransferReset();
}
