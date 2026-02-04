import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/beneficiary_model.dart';
import '../models/transfer_model.dart';

abstract class TransfersRemoteDataSource {
  Future<List<BeneficiaryModel>> getBeneficiaries();
  Future<TransferModel> createTransfer({
    required String fromAccountId,
    required String beneficiaryId,
    required double amount,
    required String currency,
    String? description,
  });
  Future<TransferModel> confirmTransfer(String transferId);
  Future<List<TransferModel>> getTransfers();
}

class TransfersRemoteDataSourceImpl implements TransfersRemoteDataSource {
  final Dio _dio;

  TransfersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    try {
      final response = await _dio.get(ApiConstants.beneficiaries);
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al obtener beneficiarios',
        );
      }

      final data = responseData['data'] as List<dynamic>;
      return data
          .map(
            (json) => BeneficiaryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al obtener beneficiarios',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error inesperado al obtener beneficiarios',
      );
    }
  }

  @override
  Future<TransferModel> createTransfer({
    required String fromAccountId,
    required String beneficiaryId,
    required double amount,
    required String currency,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.transfers,
        data: {
          'from_account_id': fromAccountId,
          'beneficiary_id': beneficiaryId,
          'amount': amount,
          'currency': currency,
          if (description != null) 'description': description,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al crear transferencia',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return TransferModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al crear transferencia',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error inesperado al crear transferencia');
    }
  }

  @override
  Future<TransferModel> confirmTransfer(String transferId) async {
    try {
      final response = await _dio.post(
        ApiConstants.confirmTransfer(transferId),
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al confirmar transferencia',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return TransferModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al confirmar transferencia',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error inesperado al confirmar transferencia',
      );
    }
  }

  @override
  Future<List<TransferModel>> getTransfers() async {
    try {
      final response = await _dio.get(ApiConstants.transfers);
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al obtener transferencias',
        );
      }

      final data = responseData['data'] as List<dynamic>;
      return data
          .map((json) => TransferModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al obtener transferencias',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error inesperado al obtener transferencias',
      );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data['error'] is Map) {
        return data['error']['message'] as String?;
      }
      return data['message'] as String?;
    }
    return null;
  }
}
