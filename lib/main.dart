import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/accounts/presentation/bloc/bloc.dart';
import 'features/auth/presentation/bloc/bloc.dart';
import 'features/cards/presentation/bloc/bloc.dart';
import 'features/transactions/presentation/bloc/bloc.dart';
import 'features/transfers/presentation/bloc/bloc.dart';
import 'features/user/presentation/bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await initializeDependencies();

  runApp(const InterligoApp());
}

class InterligoApp extends StatelessWidget {
  const InterligoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final authBloc = sl<AuthBloc>();
        final userBloc = sl<UserBloc>();

        // Connect AuthBloc with UserBloc
        authBloc.onLoginSuccess = () {
          userBloc.add(const UserLoadRequested());
        };
        authBloc.onLogoutSuccess = () {
          userBloc.add(const UserCleared());
        };

        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<UserBloc>.value(value: userBloc),
            BlocProvider<AccountsBloc>(create: (_) => sl<AccountsBloc>()),
            BlocProvider<TransactionsBloc>(
              create: (_) => sl<TransactionsBloc>(),
            ),
            BlocProvider<TransfersBloc>(create: (_) => sl<TransfersBloc>()),
            BlocProvider<CardsBloc>(create: (_) => sl<CardsBloc>()),
          ],
          child: Builder(
            builder: (context) {
              final router = AppRouter.router(authBloc);

              return MaterialApp.router(
                title: 'Interligo',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                routerConfig: router,
              );
            },
          ),
        );
      },
    );
  }
}
