import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../bloc/bloc.dart';

class TransferReviewPage extends StatelessWidget {
  final TransferEntity transfer;
  final BeneficiaryEntity beneficiary;
  final AccountEntity sourceAccount;

  const TransferReviewPage({
    super.key,
    required this.transfer,
    required this.beneficiary,
    required this.sourceAccount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransfersBloc, TransfersState>(
      listener: (context, state) {
        if (state is TransferCreated) {
          context.pushReplacement(
            RoutePaths.transferConfirmation,
            extra: {'transfer': state.transfer},
          );
        } else if (state is TransferError) {
          context.showSnackBar(state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Confirmar transferencia')),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Amount display
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Monto a transferir',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                Formatters.currency(
                                  transfer.amount,
                                  currency: sourceAccount.currency,
                                ),
                                style: AppTypography.displayLarge.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Transfer details
                        _buildDetailCard(
                          title: 'Destinatario',
                          children: [
                            _buildDetailRow(
                              icon: LucideIcons.user,
                              label: 'Nombre',
                              value: beneficiary.name,
                            ),
                            _buildDetailRow(
                              icon: LucideIcons.creditCard,
                              label: 'Cuenta',
                              value: beneficiary.maskedAccountNumber,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        _buildDetailCard(
                          title: 'Cuenta de origen',
                          children: [
                            _buildDetailRow(
                              icon: LucideIcons.wallet,
                              label: 'Cuenta',
                              value: sourceAccount.alias,
                            ),
                            _buildDetailRow(
                              icon: LucideIcons.dollarSign,
                              label: 'Saldo disponible',
                              value: Formatters.currency(
                                sourceAccount.availableBalance,
                                currency: sourceAccount.currency,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Warning
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.triangleAlert,
                                size: 20.sp,
                                color: AppColors.warning,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Verifica los datos antes de confirmar. Esta operación no se puede deshacer.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Buttons
                BlocBuilder<TransfersBloc, TransfersState>(
                  builder: (context, state) {
                    final isLoading = state is TransferCreating;

                    return Column(
                      children: [
                        AppButton(
                          text: 'Confirmar transferencia',
                          isLoading: isLoading,
                          onPressed: () => _onConfirm(context),
                        ),
                        SizedBox(height: 12.h),
                        AppButton(
                          text: 'Cancelar',
                          variant: AppButtonVariant.outlined,
                          onPressed: isLoading ? null : () => context.pop(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: AppColors.textTertiary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm(BuildContext context) {
    context.read<TransfersBloc>().add(
      CreateTransferRequested(
        beneficiaryId: beneficiary.id,
        sourceAccountId: sourceAccount.id,
        amount: transfer.amount,
      ),
    );
  }
}
