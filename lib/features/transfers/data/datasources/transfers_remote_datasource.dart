import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/beneficiary_model.dart';
import '../models/transfer_model.dart';

abstract class TransfersRemoteDataSource {
  Future<List<BeneficiaryModel>> getBeneficiaries();
  Future<TransferModel> createTransfer({
    required String beneficiaryId,
    required String sourceAccountId,
    required double amount,
  });
  Future<TransferModel> confirmTransfer(String transferId);
}

class TransfersRemoteDataSourceImpl implements TransfersRemoteDataSource {
  final Dio _dio;

  TransfersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    try {
      final response = await _dio.get(ApiConstants.beneficiaries);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => BeneficiaryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] as String? ??
            'Error al obtener beneficiarios',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado al obtener beneficiarios');
    }
  }

  @override
  Future<TransferModel> createTransfer({
    required String beneficiaryId,
    required String sourceAccountId,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.transfers,
        data: {
          'beneficiary_id': beneficiaryId,
          'source_account_id': sourceAccountId,
          'amount': amount,
        },
      );

      return TransferModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] as String? ?? 'Error al crear transferencia',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado al crear transferencia');
    }
  }

  @override
  Future<TransferModel> confirmTransfer(String transferId) async {
    try {
      final response = await _dio.post(
        ApiConstants.confirmTransfer(transferId),
      );

      return TransferModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] as String? ??
            'Error al confirmar transferencia',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Error inesperado al confirmar transferencia',
      );
    }
  }
}
