import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/transfer_entity.dart';

class TransferConfirmationPage extends StatelessWidget {
  final TransferEntity transfer;

  const TransferConfirmationPage({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final isSuccess = transfer.isCompleted || transfer.isPending;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success/Error Icon
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? LucideIcons.circleCheck : LucideIcons.circleX,
                  size: 56.sp,
                  color: isSuccess ? AppColors.success : AppColors.error,
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                isSuccess ? 'Transferencia exitosa' : 'Transferencia fallida',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              // Subtitle
              Text(
                isSuccess
                    ? 'Tu transferencia ha sido procesada correctamente'
                    : 'Hubo un error al procesar tu transferencia',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              // Transfer details
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Text(
                      'Monto transferido',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      Formatters.currency(transfer.amount),
                      style: AppTypography.displayMedium.copyWith(
                        color: isSuccess ? AppColors.success : AppColors.error,
                      ),
                    ),
                    if (transfer.timestamp != null) ...[
                      SizedBox(height: 16.h),
                      Divider(color: AppColors.divider),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fecha y hora',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            Formatters.dateTime(transfer.timestamp!),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Referencia',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          transfer.id.isNotEmpty ? transfer.id : 'N/A',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estado',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              transfer.status,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            _getStatusText(transfer.status),
                            style: AppTypography.labelSmall.copyWith(
                              color: _getStatusColor(transfer.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Buttons
              AppButton(
                text: 'Volver al inicio',
                onPressed: () => context.go(RoutePaths.dashboard),
              ),
              SizedBox(height: 12.h),
              AppButton(
                text: 'Nueva transferencia',
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  context.go(RoutePaths.dashboard);
                  // Small delay to allow navigation to complete
                  Future.delayed(const Duration(milliseconds: 100), () {
                    context.push(RoutePaths.selectBeneficiary);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TransferStatus status) {
    switch (status) {
      case TransferStatus.completed:
        return AppColors.success;
      case TransferStatus.pending:
        return AppColors.warning;
      case TransferStatus.failed:
        return AppColors.error;
    }
  }

  String _getStatusText(TransferStatus status) {
    switch (status) {
      case TransferStatus.completed:
        return 'COMPLETADO';
      case TransferStatus.pending:
        return 'PENDIENTE';
      case TransferStatus.failed:
        return 'FALLIDO';
    }
  }
}
