import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(title: const Text('Mis Tarjetas')),
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
            child: Column(
              children: [
                if (isFromCache) const OfflineBanner(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final isUpdating = updatingCardId == card.id;
                      return _buildCardWidget(context, card, isUpdating);
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

  Widget _buildCardWidget(
    BuildContext context,
    CardEntity card,
    bool isUpdating,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: card.isFrozen
                    ? [
                        AppColors.cardFrozen,
                        AppColors.cardFrozen.withValues(alpha: 0.8),
                      ]
                    : [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color:
                      (card.isFrozen ? AppColors.cardFrozen : AppColors.primary)
                          .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.typeDisplayName,
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (card.isFrozen)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.snowflake,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'CONGELADA',
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    card.cardNumberMasked,
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                      letterSpacing: 4,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TITULAR',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            card.holderName,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Freeze/Unfreeze button
                      _buildFreezeButton(context, card, isUpdating),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUpdating)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFreezeButton(
    BuildContext context,
    CardEntity card,
    bool isUpdating,
  ) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: isUpdating ? null : () => _showFreezeConfirmation(context, card),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                card.isFrozen ? LucideIcons.sun : LucideIcons.snowflake,
                size: 16.sp,
                color: Colors.white,
              ),
              SizedBox(width: 4.w),
              Text(
                card.isFrozen ? 'Activar' : 'Congelar',
                style: AppTypography.labelSmall.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFreezeConfirmation(BuildContext context, CardEntity card) {
    final action = card.isFrozen ? 'activar' : 'congelar';
    final newStatus = card.isFrozen ? CardStatus.active : CardStatus.frozen;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${action.capitalize} tarjeta'),
        content: Text(
          '¿Estás seguro de que deseas $action tu tarjeta terminada en ${card.lastFour}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CardsBloc>().add(
                CardFreezeToggled(cardId: card.id, newStatus: newStatus),
              );
            },
            child: Text(action.capitalize),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        },
      ),
    );
  }
}
