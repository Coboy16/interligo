import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<PaginatedTransactionsModel> getTransactions({
    required String accountId,
    int page = 1,
    int limit = 10,
  });
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final Dio _dio;

  TransactionsRemoteDataSourceImpl(this._dio);

  @override
  Future<PaginatedTransactionsModel> getTransactions({
    required String accountId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.accountTransactions(accountId),
        queryParameters: {'page': page, 'limit': limit},
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al obtener transacciones',
        );
      }

      // API returns {success, data: {data: [], pagination: {}}}
      final data = responseData['data'] as Map<String, dynamic>;

      return PaginatedTransactionsModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al obtener transacciones',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error inesperado al obtener transacciones',
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
