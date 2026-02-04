import 'package:equatable/equatable.dart';

enum TransferStatus { pending, completed, failed }

class TransferEntity extends Equatable {
  final String id;
  final String beneficiaryId;
  final String sourceAccountId;
  final double amount;
  final TransferStatus status;
  final DateTime? timestamp;

  const TransferEntity({
    required this.id,
    required this.beneficiaryId,
    required this.sourceAccountId,
    required this.amount,
    required this.status,
    this.timestamp,
  });

  bool get isPending => status == TransferStatus.pending;
  bool get isCompleted => status == TransferStatus.completed;
  bool get isFailed => status == TransferStatus.failed;

  TransferEntity copyWith({
    String? id,
    String? beneficiaryId,
    String? sourceAccountId,
    double? amount,
    TransferStatus? status,
    DateTime? timestamp,
  }) {
    return TransferEntity(
      id: id ?? this.id,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
    id,
    beneficiaryId,
    sourceAccountId,
    amount,
    status,
    timestamp,
  ];
}
