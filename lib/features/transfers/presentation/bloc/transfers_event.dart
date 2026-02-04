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
  final String fromAccountId;
  final String beneficiaryId;
  final double amount;
  final String currency;
  final String? description;

  const CreateTransferRequested({
    required this.fromAccountId,
    required this.beneficiaryId,
    required this.amount,
    required this.currency,
    this.description,
  });

  @override
  List<Object?> get props => [
    fromAccountId,
    beneficiaryId,
    amount,
    currency,
    description,
  ];
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
