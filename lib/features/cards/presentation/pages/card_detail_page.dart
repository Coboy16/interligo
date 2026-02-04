import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class CardDetailPage extends StatelessWidget {
  final String cardId;

  const CardDetailPage({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Tarjeta')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_card, size: 64.sp, color: AppColors.primary),
              SizedBox(height: 16.h),
              Text('Detalle de Tarjeta', style: AppTypography.headlineMedium),
              SizedBox(height: 8.h),
              Text(
                'ID: $cardId',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
