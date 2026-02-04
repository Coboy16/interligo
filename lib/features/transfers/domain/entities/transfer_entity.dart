import 'package:equatable/equatable.dart';

enum TransferStatus { pending, completed, failed, cancelled }

class TransferEntity extends Equatable {
  final String id;
  final String? userId;
  final String fromAccountId;
  final String beneficiaryId;
  final double amount;
  final String currency;
  final String? description;
  final TransferStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;

  const TransferEntity({
    required this.id,
    this.userId,
    required this.fromAccountId,
    required this.beneficiaryId,
    required this.amount,
    required this.currency,
    this.description,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
  });

  bool get isPending => status == TransferStatus.pending;
  bool get isCompleted => status == TransferStatus.completed;
  bool get isFailed => status == TransferStatus.failed;
  bool get isCancelled => status == TransferStatus.cancelled;

  TransferEntity copyWith({
    String? id,
    String? userId,
    String? fromAccountId,
    String? beneficiaryId,
    double? amount,
    String? currency,
    String? description,
    TransferStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
  }) {
    return TransferEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    fromAccountId,
    beneficiaryId,
    amount,
    currency,
    description,
    status,
    createdAt,
    confirmedAt,
  ];
}
