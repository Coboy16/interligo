import '../../domain/entities/transfer_entity.dart';

class TransferModel extends TransferEntity {
  const TransferModel({
    required super.id,
    super.userId,
    required super.fromAccountId,
    required super.beneficiaryId,
    required super.amount,
    required super.currency,
    super.description,
    required super.status,
    required super.createdAt,
    super.confirmedAt,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      fromAccountId: json['from_account_id'] as String,
      beneficiaryId: json['beneficiary_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      description: json['description'] as String?,
      status: _parseStatus(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
    );
  }

  static TransferStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return TransferStatus.pending;
      case 'COMPLETED':
        return TransferStatus.completed;
      case 'FAILED':
        return TransferStatus.failed;
      case 'CANCELLED':
        return TransferStatus.cancelled;
      default:
        return TransferStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'from_account_id': fromAccountId,
      'beneficiary_id': beneficiaryId,
      'amount': amount,
      'currency': currency,
      'description': description,
      'status': status.name.toUpperCase(),
      'created_at': createdAt.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
    };
  }

  factory TransferModel.fromEntity(TransferEntity entity) {
    return TransferModel(
      id: entity.id,
      userId: entity.userId,
      fromAccountId: entity.fromAccountId,
      beneficiaryId: entity.beneficiaryId,
      amount: entity.amount,
      currency: entity.currency,
      description: entity.description,
      status: entity.status,
      createdAt: entity.createdAt,
      confirmedAt: entity.confirmedAt,
    );
  }
}
