import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/account_entity.dart';
import '../bloc/bloc.dart';

class AccountDetailPage extends StatefulWidget {
  final String accountId;

  const AccountDetailPage({
    super.key,
    required this.accountId,
  });

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountsBloc>().add(AccountDetailRequested(widget.accountId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Cuenta'),
      ),
      body: BlocBuilder<AccountsBloc, AccountsState>(
        builder: (context, state) {
          if (state is AccountDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountDetailError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<AccountsBloc>()
                    .add(AccountDetailRequested(widget.accountId));
              },
            );
          }

          if (state is AccountDetailLoaded) {
            return _buildContent(context, state.account);
          }

          // Fallback for accounts list state
          if (state is AccountsLoaded) {
            final account = state.accounts.firstWhere(
              (a) => a.id == widget.accountId,
              orElse: () => throw Exception('Account not found'),
            );
            return _buildContent(context, account);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AccountEntity account) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      account.alias,
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        account.currency,
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  'Saldo disponible',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  Formatters.currency(
                    account.availableBalance,
                    currency: account.currency,
                  ),
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BalanceInfo(
                      label: 'Saldo contable',
                      value: Formatters.currency(
                        account.ledgerBalance,
                        currency: account.currency,
                      ),
                    ),
                    _BalanceInfo(
                      label: 'Pendiente',
                      value: Formatters.currency(
                        account.pendingBalance,
                        currency: account.currency,
                      ),
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Actions
          Text(
            'Acciones',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: LucideIcons.arrowRightLeft,
                  label: 'Transferir',
                  onTap: () => context.push(
                    RoutePaths.selectBeneficiary,
                    extra: {'sourceAccount': account},
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ActionCard(
                  icon: LucideIcons.listOrdered,
                  label: 'Movimientos',
                  onTap: () => context.push(
                    '/dashboard/account/${account.id}/transactions',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // View Transactions Button
          AppButton(
            text: 'Ver todos los movimientos',
            icon: LucideIcons.list,
            variant: AppButtonVariant.outlined,
            onPressed: () => context.push(
              '/dashboard/account/${account.id}/transactions',
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceInfo extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  const _BalanceInfo({
    required this.label,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTypography.moneyMedium.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
