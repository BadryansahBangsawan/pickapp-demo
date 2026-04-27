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
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PickupAppBar(
        title: 'PickPay',
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
            return const _WalletLoading();
          }

          if (state.hasError && state.transactions.isEmpty) {
            return PickupErrorState(
              title: 'Gagal memuat wallet',
              message: state.errorMessage!,
              onRetry: () => context.read<WalletCubit>().loadWallet(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<WalletCubit>().refreshWallet(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: BalanceCard(
                      balance: state.balance,
                      onTopUp: () => context.push(RouteNames.topUp),
                      onTransfer: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transfer akan segera hadir.'),
                          ),
                        );
                      },
                      onHistory: () {
                        // Scroll ke bawah — riwayat sudah di bawah
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.base,
                      AppSpacing.sm,
                      AppSpacing.base,
                      AppSpacing.md,
                    ),
                    child: Text('Riwayat Transaksi', style: AppTypography.h3),
                  ),
                ),
                if (state.transactions.isEmpty)
                  const SliverFillRemaining(
                    child: PickupEmptyState(
                      title: 'Belum ada transaksi',
                      message:
                          'Riwayat top up, pembayaran, dan transfer akan muncul di sini.',
                      icon: Icons.receipt_long_outlined,
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: state.transactions.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: AppSpacing.base + 40 + AppSpacing.md,
                    ),
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: state.transactions[index],
                      );
                    },
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WalletLoading extends StatelessWidget {
  const _WalletLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PickupShimmerBox(height: 160, radius: AppRadius.lg),
          const SizedBox(height: AppSpacing.xl),
          const PickupShimmerBox(height: 18, width: 160),
          const SizedBox(height: AppSpacing.base),
          Expanded(
            child: PickupListShimmer(
              itemBuilder: (context, index) => Row(
                children: const [
                  PickupShimmerBox(
                    height: 40,
                    width: 40,
                    radius: AppRadius.sm,
                  ),
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
          ),
        ],
      ),
    );
  }
}
