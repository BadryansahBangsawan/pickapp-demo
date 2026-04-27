import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../../../../core/widgets/pickup_error_state.dart';
import '../../../../core/widgets/pickup_shimmer.dart';
import '../bloc/wallet_cubit.dart';
import '../models/payment_models.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PickupAppBar(
        title: 'Payment',
        showBack: false,
        bottomBorder: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.credit_card_outlined),
            tooltip: 'Metode Pembayaran',
            onPressed: () => context.push(RouteNames.paymentMethods),
          ),
        ],
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state.isLoading && state.transactions.isEmpty) {
            return const _HistoryLoading();
          }

          if (state.hasError && state.transactions.isEmpty) {
            return PickupErrorState(
              title: 'Gagal memuat riwayat',
              message: state.errorMessage!,
              onRetry: () => context.read<WalletCubit>().loadWallet(),
            );
          }

          final transactions = state.visibleTransactions;

          return RefreshIndicator(
            onRefresh: () => context.read<WalletCubit>().refreshWallet(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.base,
                AppSpacing.base,
                AppSpacing.xl,
              ),
              children: [
                BalanceCard(
                  balance: state.balance,
                  onTopUp: () => context.push(RouteNames.topUp),
                  onTransfer: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Transfer antar pengguna akan tersedia segera.',
                        ),
                      ),
                    );
                  },
                  onHistory: () => context.read<WalletCubit>().setHistoryFilter(
                    WalletHistoryFilter.purchases,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _HistoryFilter(
                  selectedFilter: state.historyFilter,
                  onChanged: (filter) =>
                      context.read<WalletCubit>().setHistoryFilter(filter),
                ),
                const SizedBox(height: AppSpacing.base),
                Row(
                  children: [
                    Text(
                      state.historyFilter == WalletHistoryFilter.purchases
                          ? 'Riwayat Pembelian'
                          : 'Semua Transaksi',
                      style: AppTypography.h3,
                    ),
                    const Spacer(),
                    Text(
                      '${transactions.length} item',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (transactions.isEmpty)
                  PickupEmptyState(
                    title: state.historyFilter == WalletHistoryFilter.purchases
                        ? 'Belum ada riwayat pembelian'
                        : 'Belum ada transaksi',
                    message:
                        state.historyFilter == WalletHistoryFilter.purchases
                        ? 'Pembayaran dari PickRide, PickFood, dan PickSend akan tampil di sini.'
                        : 'Top up, pembayaran, refund, dan cashback akan tampil di sini.',
                    icon: Icons.receipt_long_outlined,
                  )
                else
                  ..._buildHistoryTiles(transactions),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildHistoryTiles(List<Transaction> transactions) {
    final widgets = <Widget>[];
    for (var i = 0; i < transactions.length; i++) {
      widgets.add(TransactionTile(transaction: transactions[i]));
      if (i < transactions.length - 1) {
        widgets.add(const Divider(height: 1, indent: 40 + AppSpacing.md));
      }
    }
    return widgets;
  }
}

class _HistoryFilter extends StatelessWidget {
  const _HistoryFilter({required this.selectedFilter, required this.onChanged});

  final WalletHistoryFilter selectedFilter;
  final ValueChanged<WalletHistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        ChoiceChip(
          label: const Text('Pembelian'),
          selected: selectedFilter == WalletHistoryFilter.purchases,
          onSelected: (_) => onChanged(WalletHistoryFilter.purchases),
        ),
        ChoiceChip(
          label: const Text('Semua'),
          selected: selectedFilter == WalletHistoryFilter.all,
          onSelected: (_) => onChanged(WalletHistoryFilter.all),
        ),
      ],
    );
  }
}

class _HistoryLoading extends StatelessWidget {
  const _HistoryLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: PickupListShimmer(
        itemBuilder: (context, index) => Row(
          children: const [
            PickupShimmerBox(height: 40, width: 40, radius: AppRadius.sm),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickupShimmerBox(height: 14, width: 180),
                  SizedBox(height: AppSpacing.sm),
                  PickupShimmerBox(height: 12, width: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
