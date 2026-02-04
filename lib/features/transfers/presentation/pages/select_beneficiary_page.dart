import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/beneficiary_entity.dart';
import '../bloc/bloc.dart';

class SelectBeneficiaryPage extends StatefulWidget {
  final AccountEntity? sourceAccount;

  const SelectBeneficiaryPage({
    super.key,
    this.sourceAccount,
  });

  @override
  State<SelectBeneficiaryPage> createState() => _SelectBeneficiaryPageState();
}

class _SelectBeneficiaryPageState extends State<SelectBeneficiaryPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransfersBloc>().add(const BeneficiariesLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar destinatario'),
      ),
      body: BlocBuilder<TransfersBloc, TransfersState>(
        builder: (context, state) {
          if (state is BeneficiariesLoading) {
            return _buildSkeletonList();
          }

          if (state is BeneficiariesError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<TransfersBloc>()
                    .add(const BeneficiariesLoadRequested());
              },
            );
          }

          if (state is BeneficiariesLoaded) {
            if (state.beneficiaries.isEmpty) {
              return EmptyView(
                title: 'Sin beneficiarios',
                subtitle: 'No tienes beneficiarios registrados',
                icon: LucideIcons.users,
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.beneficiaries.length,
              itemBuilder: (context, index) {
                final beneficiary = state.beneficiaries[index];
                return _buildBeneficiaryTile(beneficiary);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBeneficiaryTile(BeneficiaryEntity beneficiary) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => _onBeneficiarySelected(beneficiary),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    beneficiary.name.substring(0, 1).toUpperCase(),
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beneficiary.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      beneficiary.maskedAccountNumber,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: AppColors.textTertiary,
                size: 20.sp,
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
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: const BoxDecoration(
                      color: AppColors.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Juan Pérez',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '****4532',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onBeneficiarySelected(BeneficiaryEntity beneficiary) {
    if (widget.sourceAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una cuenta de origen primero')),
      );
      return;
    }

    context.push(
      RoutePaths.transferAmount,
      extra: {
        'beneficiary': beneficiary,
        'sourceAccount': widget.sourceAccount,
      },
    );
  }
}
