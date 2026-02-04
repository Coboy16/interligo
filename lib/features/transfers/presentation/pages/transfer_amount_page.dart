import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/entities/transfer_entity.dart';

class TransferAmountPage extends StatefulWidget {
  final BeneficiaryEntity beneficiary;
  final AccountEntity sourceAccount;

  const TransferAmountPage({
    super.key,
    required this.beneficiary,
    required this.sourceAccount,
  });

  @override
  State<TransferAmountPage> createState() => _TransferAmountPageState();
}

class _TransferAmountPageState extends State<TransferAmountPage> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.tryParse(
        _amountController.text.replaceAll(',', '.'),
      );

      if (amount == null || amount <= 0) {
        setState(() {
          _errorMessage = 'Ingresa un monto válido';
        });
        return;
      }

      if (amount > widget.sourceAccount.availableBalance) {
        setState(() {
          _errorMessage = 'Saldo insuficiente';
        });
        return;
      }

      // Create a temporary transfer entity for review
      final transfer = TransferEntity(
        id: '', // Will be assigned by backend
        beneficiaryId: widget.beneficiary.id,
        sourceAccountId: widget.sourceAccount.id,
        amount: amount,
        status: TransferStatus.pending,
      );

      context.push(
        RoutePaths.transferReview,
        extra: {
          'transfer': transfer,
          'beneficiary': widget.beneficiary,
          'sourceAccount': widget.sourceAccount,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monto a transferir')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Beneficiary info
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.beneficiary.name.substring(0, 1).toUpperCase(),
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.beneficiary.name,
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          widget.beneficiary.maskedAccountNumber,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Amount input
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: AppTypography.moneyLarge,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixText: '\$ ',
                        prefixStyle: AppTypography.moneyLarge.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        errorText: _errorMessage,
                      ),
                      onChanged: (_) {
                        if (_errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un monto';
                        }
                        final amount = double.tryParse(
                          value.replaceAll(',', '.'),
                        );
                        if (amount == null || amount <= 0) {
                          return 'Monto inválido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Available balance
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.wallet,
                      size: 18.sp,
                      color: AppColors.info,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Disponible: ${Formatters.currency(widget.sourceAccount.availableBalance, currency: widget.sourceAccount.currency)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Continue button
              AppButton(text: 'Continuar', onPressed: _onContinue),
            ],
          ),
        ),
      ),
    );
  }
}
