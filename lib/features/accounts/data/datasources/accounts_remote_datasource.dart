import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/account_model.dart';

abstract class AccountsRemoteDataSource {
  Future<List<AccountModel>> getAccounts();
  Future<AccountModel> getAccountById(String id);
}

class AccountsRemoteDataSourceImpl implements AccountsRemoteDataSource {
  final Dio _dio;

  AccountsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<AccountModel>> getAccounts() async {
    try {
      final response = await _dio.get(ApiConstants.accounts);
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ?? 'Error al obtener cuentas',
        );
      }

      final data = responseData['data'] as List<dynamic>;
      return data
          .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ?? 'Error al obtener cuentas',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error inesperado al obtener cuentas');
    }
  }

  @override
  Future<AccountModel> getAccountById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.accounts}/$id');
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ?? 'Error al obtener cuenta',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return AccountModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ?? 'Error al obtener cuenta',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error inesperado al obtener cuenta');
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
