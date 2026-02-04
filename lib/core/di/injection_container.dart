import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

// Auth Feature
import '../../features/auth/data/datasources/datasources.dart';
import '../../features/auth/data/repositories/repositories.dart';
import '../../features/auth/domain/repositories/repositories.dart';
import '../../features/auth/domain/usecases/usecases.dart';
import '../../features/auth/presentation/bloc/bloc.dart';

// User Feature
import '../../features/user/data/repositories/repositories.dart';
import '../../features/user/domain/repositories/repositories.dart';
import '../../features/user/domain/usecases/usecases.dart';
import '../../features/user/presentation/bloc/bloc.dart';

// Accounts Feature
import '../../features/accounts/data/datasources/datasources.dart';
import '../../features/accounts/data/repositories/repositories.dart';
import '../../features/accounts/domain/repositories/repositories.dart';
import '../../features/accounts/domain/usecases/usecases.dart';
import '../../features/accounts/presentation/bloc/bloc.dart';

// Transactions Feature
import '../../features/transactions/data/datasources/datasources.dart';
import '../../features/transactions/data/repositories/repositories.dart';
import '../../features/transactions/domain/repositories/repositories.dart';
import '../../features/transactions/domain/usecases/usecases.dart';
import '../../features/transactions/presentation/bloc/bloc.dart';

// Transfers Feature
import '../../features/transfers/data/datasources/datasources.dart';
import '../../features/transfers/data/repositories/repositories.dart';
import '../../features/transfers/domain/repositories/repositories.dart';
import '../../features/transfers/domain/usecases/usecases.dart';
import '../../features/transfers/presentation/bloc/bloc.dart';

// Cards Feature
import '../../features/cards/data/datasources/datasources.dart';
import '../../features/cards/data/repositories/repositories.dart';
import '../../features/cards/domain/repositories/repositories.dart';
import '../../features/cards/domain/usecases/usecases.dart';
import '../../features/cards/presentation/bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ==========================================================================
  // EXTERNAL
  // ==========================================================================
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());

  // ==========================================================================
  // CORE
  // ==========================================================================
  sl.registerLazySingleton(() => ApiClient(sl(), sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => AppDatabase());

  // ==========================================================================
  // AUTH FEATURE
  // ==========================================================================
  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  // BLoC - Singleton for auth to maintain state across app
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // ==========================================================================
  // USER FEATURE
  // ==========================================================================
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // BLoC - Singleton for user to maintain state across app
  sl.registerLazySingleton(
    () => UserBloc(getCurrentUserUseCase: sl()),
  );

  // ==========================================================================
  // ACCOUNTS FEATURE
  // ==========================================================================
  // DataSources
  sl.registerLazySingleton<AccountsRemoteDataSource>(
    () => AccountsRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<AccountsLocalDataSource>(
    () => AccountsLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AccountsRepository>(
    () => AccountsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetAccountsUseCase(sl()));
  sl.registerLazySingleton(() => GetAccountByIdUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AccountsBloc(getAccountsUseCase: sl(), getAccountByIdUseCase: sl()),
  );

  // ==========================================================================
  // TRANSACTIONS FEATURE
  // ==========================================================================
  // DataSources
  sl.registerLazySingleton<TransactionsRemoteDataSource>(
    () => TransactionsRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<TransactionsLocalDataSource>(
    () => TransactionsLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));

  // BLoC
  sl.registerFactory(() => TransactionsBloc(getTransactionsUseCase: sl()));

  // ==========================================================================
  // TRANSFERS FEATURE
  // ==========================================================================
  // DataSources
  sl.registerLazySingleton<TransfersRemoteDataSource>(
    () => TransfersRemoteDataSourceImpl(sl<ApiClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<TransfersRepository>(
    () => TransfersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetBeneficiariesUseCase(sl()));
  sl.registerLazySingleton(() => CreateTransferUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmTransferUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => TransfersBloc(
      getBeneficiariesUseCase: sl(),
      createTransferUseCase: sl(),
      confirmTransferUseCase: sl(),
    ),
  );

  // ==========================================================================
  // CARDS FEATURE
  // ==========================================================================
  // DataSources
  sl.registerLazySingleton<CardsRemoteDataSource>(
    () => CardsRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<CardsLocalDataSource>(
    () => CardsLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<CardsRepository>(
    () => CardsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetCardsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleCardFreezeUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => CardsBloc(getCardsUseCase: sl(), toggleCardFreezeUseCase: sl()),
  );
}
