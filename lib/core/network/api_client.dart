import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../constants/storage_constants.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient(this._dio, this._storage) {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage, _dio),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;

  _AuthInterceptor(this._storage, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login and refresh endpoints
    if (options.path.contains('/auth/oidc/token') ||
        options.path.contains('/auth/oidc/refresh')) {
      return handler.next(options);
    }

    final token = await _storage.read(key: StorageConstants.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final token = await _storage.read(key: StorageConstants.accessToken);
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (_) {
        // Refresh failed, clear tokens
        await _clearTokens();
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = await _storage.read(key: StorageConstants.refreshToken);
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        ApiConstants.authRefresh,
        data: {
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>?;
        if (data != null) {
          await _storage.write(
            key: StorageConstants.accessToken,
            value: data['access_token'] as String,
          );
          await _storage.write(
            key: StorageConstants.refreshToken,
            value: data['refresh_token'] as String,
          );
          final expiresIn = data['expires_in'] as int;
          final expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
          await _storage.write(
            key: StorageConstants.tokenExpiry,
            value: expiryDate.toIso8601String(),
          );
          return true;
        }
      }
    } catch (_) {
      // Refresh failed
    }
    return false;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: StorageConstants.accessToken);
    await _storage.delete(key: StorageConstants.refreshToken);
    await _storage.delete(key: StorageConstants.tokenExpiry);
  }
}
