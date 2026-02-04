import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/card_entity.dart';
import '../bloc/bloc.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CardsBloc>().add(const CardsLoadRequested());
  }

  Future<void> _onRefresh() async {
    context.read<CardsBloc>().add(const CardsRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Mis Tarjetas',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<CardsBloc, CardsState>(
        listener: (context, state) {
          if (state is CardUpdateSuccess) {
            final action = state.card.isFrozen ? 'congelada' : 'activada';
            context.showSnackBar('Tarjeta $action exitosamente');
          } else if (state is CardUpdateError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is CardsLoading) {
            return _buildSkeletonList();
          }

          if (state is CardsError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<CardsBloc>().add(const CardsLoadRequested());
              },
            );
          }

          List<CardEntity> cards = [];
          bool isFromCache = false;
          String? updatingCardId;

          if (state is CardsLoaded) {
            cards = state.cards;
            isFromCache = state.isFromCache;
            updatingCardId = state.updatingCardId;
          } else if (state is CardUpdateSuccess) {
            cards = state.cards;
          } else if (state is CardUpdateError) {
            cards = state.cards;
          }

          if (cards.isEmpty) {
            return EmptyView(
              title: 'Sin tarjetas',
              subtitle: 'No tienes tarjetas registradas',
              icon: LucideIcons.creditCard,
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: Column(
              children: [
                if (isFromCache) const OfflineBanner(),
                // Hint para girar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.info,
                        size: 16.sp,
                        color: AppColors.textTertiary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Toca una tarjeta para ver el CVV',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final isUpdating = updatingCardId == card.id;
                      return _CreditCardWidget(
                        card: card,
                        isUpdating: isUpdating,
                        onFreezeToggle: () => _showFreezeConfirmation(context, card),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFreezeConfirmation(BuildContext context, CardEntity card) {
    final action = card.isFrozen ? 'activar' : 'congelar';
    final newStatus = card.isFrozen ? CardStatus.active : CardStatus.frozen;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: card.isFrozen
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                card.isFrozen ? LucideIcons.sun : LucideIcons.snowflake,
                size: 28.sp,
                color: card.isFrozen ? AppColors.success : AppColors.warning,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '${action.capitalize} tarjeta',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              card.isFrozen
                  ? 'Tu tarjeta volverá a estar activa y podrás usarla normalmente.'
                  : 'Tu tarjeta quedará temporalmente inhabilitada. Podrás activarla cuando quieras.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '**** ${card.lastFour}',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textTertiary,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.read<CardsBloc>().add(
                        CardFreezeToggled(cardId: card.id, newStatus: newStatus),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      action.capitalize,
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.h),
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(16.r),
            ),
          );
        },
      ),
    );
  }
}

class _CreditCardWidget extends StatelessWidget {
  final CardEntity card;
  final bool isUpdating;
  final VoidCallback onFreezeToggle;

  const _CreditCardWidget({
    required this.card,
    required this.isUpdating,
    required this.onFreezeToggle,
  });

  Color get _cardColor {
    if (card.isFrozen) return AppColors.cardFrozen;
    return card.brand == CardBrand.visa
        ? AppColors.cardVisa
        : AppColors.cardMastercard;
  }

  @override
  Widget build(BuildContext context) {
    final flipController = FlipCardController();

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Stack(
        children: [
          FlipCard(
            rotateSide: RotateSide.right,
            onTapFlipping: true,
            axis: FlipAxis.vertical,
            controller: flipController,
            frontWidget: _buildFrontCard(context),
            backWidget: _buildBackCard(context),
          ),
          if (isUpdating)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _cardColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pattern decorativo sutil
          Positioned(
            right: -30.w,
            top: -30.h,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: 20.w,
            bottom: -50.h,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          // Contenido
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Chip EMV
                    Container(
                      width: 45.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8.w,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1,
                              color: const Color(0xFFC5A028),
                            ),
                          ),
                          Positioned(
                            left: 16.w,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1,
                              color: const Color(0xFFC5A028),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge si está congelada
                    if (card.isFrozen)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.snowflake,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'CONGELADA',
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                // Número de tarjeta
                Text(
                  card.cardNumberMasked,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 20.h),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TITULAR',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          card.holderName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'VENCE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          card.expiryDate,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Brand logo
                    _buildBrandLogo(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _cardColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Banda magnética
          Container(
            width: double.infinity,
            height: 40.h,
            color: Colors.black.withValues(alpha: 0.8),
          ),
          SizedBox(height: 16.h),
          // CVV
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 12.w),
                    child: Text(
                      card.cvvMasked,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'CVV',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Actions
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.typeDisplayName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Freeze button
                GestureDetector(
                  onTap: onFreezeToggle,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          card.isFrozen ? LucideIcons.sun : LucideIcons.snowflake,
                          size: 13.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          card.isFrozen ? 'Activar' : 'Congelar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo() {
    if (card.brand == CardBrand.visa) {
      return Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      );
    } else {
      // Mastercard circles
      return SizedBox(
        width: 50.w,
        height: 30.h,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFEB001B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 18.w,
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
