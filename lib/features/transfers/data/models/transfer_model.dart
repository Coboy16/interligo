import '../../domain/entities/transfer_entity.dart';

class TransferModel extends TransferEntity {
  const TransferModel({
    required super.id,
    required super.beneficiaryId,
    required super.sourceAccountId,
    required super.amount,
    required super.status,
    super.timestamp,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'] as String,
      beneficiaryId: json['beneficiary_id'] as String? ?? '',
      sourceAccountId: json['source_account_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(json['status'] as String),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
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
      default:
        return TransferStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beneficiary_id': beneficiaryId,
      'source_account_id': sourceAccountId,
      'amount': amount,
      'status': status.name.toUpperCase(),
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory TransferModel.fromEntity(TransferEntity entity) {
    return TransferModel(
      id: entity.id,
      beneficiaryId: entity.beneficiaryId,
      sourceAccountId: entity.sourceAccountId,
      amount: entity.amount,
      status: entity.status,
      timestamp: entity.timestamp,
    );
  }
}
