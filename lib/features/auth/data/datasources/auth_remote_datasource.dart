import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/pkce_util.dart';
import '../../../../core/utils/logger_util.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

/// Response class for login containing both token and user
class LoginResponse {
  final TokenModel token;
  final UserModel user;

  const LoginResponse({required this.token, required this.user});
}

abstract class AuthRemoteDataSource {
  /// Login with email (sent as username) and password
  Future<LoginResponse> login({
    required String email,
    required String password,
  });

  /// Refresh the access token using refresh token
  Future<TokenModel> refreshToken(String refreshToken);

  /// Logout from the server
  Future<void> logout();

  /// Get current authenticated user
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final codeVerifier = PKCEUtil.generateVerifier();

      LoggerUtil.logAuthEvent(
        'Iniciando Login Remote',
        data: {
          'username': email,
          'grant_type': 'password',
        },
      );

      final response = await _dio.post(
        ApiConstants.authToken,
        data: {
          'username': email,
          'password': password,
          'grant_type': 'password',
          'code_verifier': codeVerifier,
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      // Extract data from API response structure {success, data, timestamp}
      if (responseData['success'] != true) {
        throw ServerException(
          message: responseData['error']?['message'] as String? ??
              'Error de autenticación',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;

      final token = TokenModel.fromJson(data);
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

      LoggerUtil.logAuthEvent(
        'Login Exitoso',
        data: {'expires_in': token.expiresIn, 'user_id': user.id},
      );

      return LoginResponse(token: token, user: user);
    } on DioException catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Dio en Login',
        data: {
          'status': e.response?.statusCode,
          'message': _extractErrorMessage(e.response?.data),
        },
      );
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ?? 'Error de autenticación',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      LoggerUtil.logAuthEvent(
        'Error Inesperado en Login',
        data: {'error': e.toString()},
      );
      throw ServerException(
        message: 'Error inesperado durante la autenticación',
      );
    }
  }

  @override
  Future<TokenModel> refreshToken(String refreshToken) async {
    try {
      LoggerUtil.logAuthEvent('Iniciando Refresh Token');

      final response = await _dio.post(
        ApiConstants.authRefresh,
        data: {
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: responseData['error']?['message'] as String? ??
              'Error al refrescar token',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      final token = TokenModel.fromJson(data);

      LoggerUtil.logAuthEvent(
        'Refresh Token Exitoso',
        data: {'expires_in': token.expiresIn},
      );

      return token;
    } on DioException catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Dio en Refresh Token',
        data: {
          'status': e.response?.statusCode,
          'message': _extractErrorMessage(e.response?.data),
        },
      );
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ?? 'Error al refrescar token',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      LoggerUtil.logAuthEvent(
        'Error Inesperado en Refresh Token',
        data: {'error': e.toString()},
      );
      throw ServerException(
        message: 'Error inesperado al refrescar token',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      LoggerUtil.logAuthEvent('Iniciando Logout');

      final response = await _dio.post(ApiConstants.authLogout);

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: responseData['error']?['message'] as String? ??
              'Error al cerrar sesión',
        );
      }

      LoggerUtil.logAuthEvent('Logout Exitoso');
    } on DioException catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Dio en Logout',
        data: {
          'status': e.response?.statusCode,
          'message': _extractErrorMessage(e.response?.data),
        },
      );
      // Don't throw on logout error - we still want to clear local data
    } catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Inesperado en Logout',
        data: {'error': e.toString()},
      );
      // Don't throw on logout error
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      LoggerUtil.logAuthEvent('Obteniendo Usuario Actual');

      final response = await _dio.get(ApiConstants.authMe);

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: responseData['error']?['message'] as String? ??
              'Error al obtener usuario',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data);

      LoggerUtil.logAuthEvent(
        'Usuario Obtenido',
        data: {'user_id': user.id},
      );

      return user;
    } on DioException catch (e) {
      LoggerUtil.logAuthEvent(
        'Error Dio en GetCurrentUser',
        data: {
          'status': e.response?.statusCode,
          'message': _extractErrorMessage(e.response?.data),
        },
      );
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ?? 'Error al obtener usuario',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      LoggerUtil.logAuthEvent(
        'Error Inesperado en GetCurrentUser',
        data: {'error': e.toString()},
      );
      throw ServerException(
        message: 'Error inesperado al obtener usuario',
      );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      // Try API error format first
      if (data['error'] is Map) {
        return data['error']['message'] as String?;
      }
      // Fallback to direct message
      return data['message'] as String?;
    }
    return null;
  }
}
