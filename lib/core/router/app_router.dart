import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/domain/entities/account_entity.dart';
import '../../features/accounts/presentation/pages/pages.dart';
import '../../features/auth/presentation/bloc/bloc.dart';
import '../../features/auth/presentation/pages/pages.dart';
import '../../features/cards/presentation/pages/pages.dart';
import '../../features/transactions/presentation/pages/pages.dart';
import '../../features/transfers/domain/entities/entities.dart';
import '../../features/transfers/presentation/pages/pages.dart';
import 'route_names.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(AuthBloc authBloc) => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == RoutePaths.login;
      final isSplash = state.matchedLocation == RoutePaths.splash;

      if (isSplash) return null;

      if (!isLoggedIn && !isLoggingIn) return RoutePaths.login;
      if (isLoggedIn && isLoggingIn) return RoutePaths.dashboard;

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            path: 'account/:accountId',
            name: RouteNames.accountDetail,
            builder: (context, state) {
              final accountId = state.pathParameters['accountId']!;
              return AccountDetailPage(accountId: accountId);
            },
            routes: [
              GoRoute(
                path: 'transactions',
                name: RouteNames.transactions,
                builder: (context, state) {
                  final accountId = state.pathParameters['accountId']!;
                  return TransactionsPage(accountId: accountId);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.cards,
        name: RouteNames.cards,
        builder: (context, state) => const CardsPage(),
        routes: [
          GoRoute(
            path: ':cardId',
            name: RouteNames.cardDetail,
            builder: (context, state) {
              final cardId = state.pathParameters['cardId']!;
              return CardDetailPage(cardId: cardId);
            },
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.selectBeneficiary,
        name: RouteNames.selectBeneficiary,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final sourceAccount = extra?['sourceAccount'] as AccountEntity?;
          return SelectBeneficiaryPage(sourceAccount: sourceAccount);
        },
      ),
      GoRoute(
        path: RoutePaths.transferAmount,
        name: RouteNames.transferAmount,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TransferAmountPage(
            beneficiary: extra['beneficiary'] as BeneficiaryEntity,
            sourceAccount: extra['sourceAccount'] as AccountEntity,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.transferReview,
        name: RouteNames.transferReview,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TransferReviewPage(
            transfer: extra['transfer'] as TransferEntity,
            beneficiary: extra['beneficiary'] as BeneficiaryEntity,
            sourceAccount: extra['sourceAccount'] as AccountEntity,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.transferConfirmation,
        name: RouteNames.transferConfirmation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TransferConfirmationPage(
            transfer: extra['transfer'] as TransferEntity,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.dashboard),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Helper to refresh router when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
