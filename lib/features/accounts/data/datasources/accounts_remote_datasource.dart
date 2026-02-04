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
      final data = response.data as List<dynamic>;
      return data
          .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] as String? ??
            'Error al obtener cuentas',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado al obtener cuentas');
    }
  }

  @override
  Future<AccountModel> getAccountById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.accounts}/$id');
      return AccountModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] as String? ?? 'Error al obtener cuenta',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado al obtener cuenta');
    }
  }
}
