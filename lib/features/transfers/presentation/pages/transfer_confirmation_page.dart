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
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/transfer_entity.dart';
import '../bloc/bloc.dart';

class TransferConfirmationPage extends StatefulWidget {
  final TransferEntity transfer;

  const TransferConfirmationPage({super.key, required this.transfer});

  @override
  State<TransferConfirmationPage> createState() =>
      _TransferConfirmationPageState();
}

class _TransferConfirmationPageState extends State<TransferConfirmationPage> {
  late TransferEntity _transfer;

  @override
  void initState() {
    super.initState();
    _transfer = widget.transfer;
  }

  void _onConfirmTransfer() {
    context.read<TransfersBloc>().add(ConfirmTransferRequested(_transfer.id));
  }

  void _startNewTransfer(BuildContext context) {
    final router = GoRouter.of(context);
    router.go(RoutePaths.dashboard);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      router.push(RoutePaths.selectBeneficiary);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransfersBloc, TransfersState>(
      listener: (context, state) {
        if (state is TransferConfirmed) {
          setState(() {
            _transfer = state.transfer;
          });
        } else if (state is TransferError) {
          context.showSnackBar(state.message, isError: true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: BlocBuilder<TransfersBloc, TransfersState>(
              builder: (context, state) {
                final isConfirming = state is TransferConfirming;
                final isPending = _transfer.isPending;
                final isCompleted = _transfer.isCompleted;
                final isFailed =
                    _transfer.status == TransferStatus.failed ||
                    _transfer.status == TransferStatus.cancelled;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Icon
                    _buildStatusIcon(isPending, isCompleted),
                    SizedBox(height: 24.h),

                    // Title
                    Text(
                      _getTitle(isPending, isCompleted),
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      _getSubtitle(isPending, isCompleted),
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    // Transfer details card
                    _buildTransferDetailsCard(isPending, isCompleted, isFailed),
                    const Spacer(),

                    // Buttons
                    if (isPending) ...[
                      // Pending state - show confirm button
                      AppButton(
                        text: 'Confirmar transferencia',
                        isLoading: isConfirming,
                        onPressed: _onConfirmTransfer,
                      ),
                      SizedBox(height: 12.h),
                      AppButton(
                        text: 'Cancelar',
                        variant: AppButtonVariant.outlined,
                        onPressed:
                            isConfirming
                                ? null
                                : () => context.go(RoutePaths.dashboard),
                      ),
                    ] else ...[
                      // Completed/Failed state - show navigation buttons
                      AppButton(
                        text: 'Volver al inicio',
                        onPressed: () => context.go(RoutePaths.dashboard),
                      ),
                      SizedBox(height: 12.h),
                      AppButton(
                        text: 'Nueva transferencia',
                        variant: AppButtonVariant.outlined,
                        onPressed: () => _startNewTransfer(context),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(bool isPending, bool isCompleted) {
    Color color;
    IconData icon;

    if (isPending) {
      color = AppColors.warning;
      icon = LucideIcons.clock;
    } else if (isCompleted) {
      color = AppColors.success;
      icon = LucideIcons.circleCheck;
    } else {
      color = AppColors.error;
      icon = LucideIcons.circleX;
    }

    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 56.sp, color: color),
    );
  }

  String _getTitle(bool isPending, bool isCompleted) {
    if (isPending) return 'Transferencia pendiente';
    if (isCompleted) return 'Transferencia exitosa';
    return 'Transferencia fallida';
  }

  String _getSubtitle(bool isPending, bool isCompleted) {
    if (isPending) {
      return 'Confirma la transferencia para completar la operación';
    }
    if (isCompleted) {
      return 'Tu transferencia ha sido procesada correctamente';
    }
    return 'Hubo un error al procesar tu transferencia';
  }

  Widget _buildTransferDetailsCard(
    bool isPending,
    bool isCompleted,
    bool isFailed,
  ) {
    Color amountColor;
    if (isPending) {
      amountColor = AppColors.warning;
    } else if (isCompleted) {
      amountColor = AppColors.success;
    } else {
      amountColor = AppColors.error;
    }

    return Container(
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
            isPending ? 'Monto a transferir' : 'Monto transferido',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            Formatters.currency(_transfer.amount, currency: _transfer.currency),
            style: AppTypography.displayMedium.copyWith(color: amountColor),
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.divider),
          SizedBox(height: 16.h),
          _buildDetailRow(
            'Fecha y hora',
            Formatters.dateTime(_transfer.confirmedAt ?? _transfer.createdAt),
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            'Referencia',
            _transfer.id.isNotEmpty ? _transfer.id : 'N/A',
            isMono: true,
          ),
          SizedBox(height: 12.h),
          _buildStatusRow(),
          if (isPending) ...[
            SizedBox(height: 16.h),
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
                    size: 18.sp,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Esta transferencia requiere tu confirmación para ser procesada.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontFamily: isMono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Estado',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _getStatusColor(_transfer.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            _getStatusText(_transfer.status),
            style: AppTypography.labelSmall.copyWith(
              color: _getStatusColor(_transfer.status),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TransferStatus status) {
    switch (status) {
      case TransferStatus.completed:
        return AppColors.success;
      case TransferStatus.pending:
        return AppColors.warning;
      case TransferStatus.failed:
      case TransferStatus.cancelled:
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
      case TransferStatus.cancelled:
        return 'CANCELADO';
    }
  }
}
