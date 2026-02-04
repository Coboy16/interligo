import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryModel extends BeneficiaryEntity {
  const BeneficiaryModel({
    required super.id,
    super.userId,
    required super.name,
    required super.accountNumber,
    required super.bankName,
    required super.bankCode,
    super.alias,
    super.email,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String,
      accountNumber: json['account_number'] as String,
      bankName: json['bank_name'] as String,
      bankCode: json['bank_code'] as String,
      alias: json['alias'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'account_number': accountNumber,
      'bank_name': bankName,
      'bank_code': bankCode,
      'alias': alias,
      'email': email,
    };
  }

  factory BeneficiaryModel.fromEntity(BeneficiaryEntity entity) {
    return BeneficiaryModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      accountNumber: entity.accountNumber,
      bankName: entity.bankName,
      bankCode: entity.bankCode,
      alias: entity.alias,
      email: entity.email,
    );
  }
}
