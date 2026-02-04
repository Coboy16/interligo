import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/bloc.dart';

class TransactionsPage extends StatefulWidget {
  final String accountId;

  const TransactionsPage({super.key, required this.accountId});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionsBloc>().add(
      TransactionsLoadRequested(widget.accountId),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TransactionsBloc>().add(
        TransactionsLoadMoreRequested(widget.accountId),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    context.read<TransactionsBloc>().add(
      TransactionsRefreshRequested(widget.accountId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state is TransactionsLoading) {
            return _buildSkeletonList();
          }

          if (state is TransactionsError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<TransactionsBloc>().add(
                  TransactionsLoadRequested(widget.accountId),
                );
              },
            );
          }

          if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return EmptyView(
                title: 'Sin movimientos',
                subtitle: 'No hay transacciones registradas',
                icon: LucideIcons.receipt,
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(
                children: [
                  if (state.isFromCache) const OfflineBanner(),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount:
                          state.transactions.length +
                          (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.transactions.length) {
                          return _buildLoadingIndicator();
                        }

                        final transaction = state.transactions[index];
                        final showDateHeader =
                            index == 0 ||
                            !_isSameDay(
                              state.transactions[index - 1].date,
                              transaction.date,
                            );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showDateHeader)
                              _buildDateHeader(transaction.date),
                            _buildTransactionTile(transaction),
                          ],
                        );
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

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Text(
        date.relativeDate,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionEntity transaction) {
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final amountPrefix = isIncome ? '+' : '';

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: amountColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                color: amountColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    Formatters.time(transaction.date),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix${Formatters.currency(transaction.amount.abs())}',
              style: AppTypography.moneyMedium.copyWith(color: amountColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 8.h),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago de servicio',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: 4.h),
                        Text('10:30', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  Text('-\$150.00', style: AppTypography.moneyMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
