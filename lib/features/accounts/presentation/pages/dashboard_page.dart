import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/bloc/bloc.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/account_entity.dart';
import '../bloc/bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountsBloc>().add(const AccountsLoadRequested());
  }

  Future<void> _onRefresh() async {
    context.read<AccountsBloc>().add(const AccountsRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cuentas'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.creditCard),
            onPressed: () => context.push(RoutePaths.cards),
            tooltip: 'Tarjetas',
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: BlocBuilder<AccountsBloc, AccountsState>(
        builder: (context, state) {
          if (state is AccountsLoading) {
            return _buildSkeletonList();
          }

          if (state is AccountsError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<AccountsBloc>().add(const AccountsLoadRequested());
              },
            );
          }

          if (state is AccountsLoaded) {
            if (state.accounts.isEmpty) {
              return EmptyView(
                title: 'Sin cuentas',
                subtitle: 'No tienes cuentas registradas',
                icon: LucideIcons.wallet,
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(
                children: [
                  if (state.isFromCache) const OfflineBanner(),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.accounts.length + 1, // +1 for quick actions
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildQuickActions(context, state.accounts);
                        }
                        final account = state.accounts[index - 1];
                        return _buildAccountCard(context, account);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, List<AccountEntity> accounts) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              icon: LucideIcons.send,
              label: 'Transferir',
              onTap: accounts.isNotEmpty
                  ? () => context.push(
                        RoutePaths.selectBeneficiary,
                        extra: {'sourceAccount': accounts.first},
                      )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _QuickActionButton(
              icon: LucideIcons.creditCard,
              label: 'Tarjetas',
              onTap: () => context.push(RoutePaths.cards),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AccountEntity account) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => context.push('/dashboard/account/${account.id}'),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      account.alias,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      account.currency,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Saldo disponible',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                Formatters.currency(
                  account.availableBalance,
                  currency: account.currency,
                ),
                style: AppTypography.moneyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    size: 14.sp,
                    color: AppColors.textTertiary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Saldo contable: ${Formatters.currency(account.ledgerBalance, currency: account.currency)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ver movimientos',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cuenta Principal',
                        style: AppTypography.titleMedium,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: const Text('USD'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Saldo disponible',
                    style: AppTypography.bodySmall,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$15,000.00',
                    style: AppTypography.moneyLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Saldo contable: \$15,500.00',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
