import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/token_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<TokenModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Simulating PKCE flow - in production use flutter_appauth
      final response = await _dio.post(
        ApiConstants.authToken,
        data: {
          'email': email,
          'password': password,
          'grant_type': 'authorization_code',
          'code_verifier': 'mock_code_verifier_${DateTime.now().millisecondsSinceEpoch}',
        },
      );

      return TokenModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] as String? ?? 'Error de autenticación',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado durante la autenticación');
    }
  }
}
