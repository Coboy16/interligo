import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<PaginatedTransactionsModel> getTransactions({
    required String accountId,
    int page = 1,
  });
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final Dio _dio;

  TransactionsRemoteDataSourceImpl(this._dio);

  @override
  Future<PaginatedTransactionsModel> getTransactions({
    required String accountId,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.accountTransactions(accountId),
        queryParameters: {'page': page},
      );

      return PaginatedTransactionsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] as String? ??
            'Error al obtener transacciones',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Error inesperado al obtener transacciones',
      );
    }
  }
}
