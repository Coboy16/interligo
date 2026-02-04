import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryModel extends BeneficiaryEntity {
  const BeneficiaryModel({
    required super.id,
    required super.name,
    required super.accountNumber,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      accountNumber: json['account_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'account_number': accountNumber,
    };
  }

  factory BeneficiaryModel.fromEntity(BeneficiaryEntity entity) {
    return BeneficiaryModel(
      id: entity.id,
      name: entity.name,
      accountNumber: entity.accountNumber,
    );
  }
}
