import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TokenEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión a internet para iniciar sesión'),
      );
    }

    try {
      final token = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveToken(token);
      return Right(token);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(AuthFailure('Error inesperado al iniciar sesión'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(CacheFailure('Error al cerrar sesión'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await localDataSource.hasToken();
      return Right(hasToken);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> refreshToken() async {
    // TODO: Implement actual token refresh logic
    return const Left(
      AuthFailure('Sesión expirada. Por favor inicia sesión nuevamente.'),
    );
  }
}
