import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/pkce_util.dart';
import '../../../../core/utils/logger_util.dart';
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
      final codeVerifier = PKCEUtil.generateVerifier();
      final codeChallenge = PKCEUtil.generateChallenge(codeVerifier);

      LoggerUtil.logAuthEvent(
        'Iniciando Login Remote',
        data: {
          'email': email,
          'grant_type': 'authorization_code',
          'code_challenge': codeChallenge,
        },
      );

      final response = await _dio.post(
        ApiConstants.authToken,
        data: {
          'email': email,
          'password': password,
          'grant_type': 'authorization_code',
          'code_verifier': codeVerifier,
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256',
        },
      );

      final token = TokenModel.fromJson(response.data as Map<String, dynamic>);
      LoggerUtil.logAuthEvent(
        'Login Exitoso',
        data: {'expires_in': token.expiresIn},
      );

      return token;
    } on DioException catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Dio en Login',
        data: {
          'status': e.response?.statusCode,
          'message': e.response?.data['message'],
        },
      );
      throw ServerException(
        message:
            e.response?.data['message'] as String? ?? 'Error de autenticación',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Inesperado en Login',
        data: {'error': e.toString()},
      );
      throw ServerException(
        message: 'Error inesperado durante la autenticación',
      );
    }
  }
}
