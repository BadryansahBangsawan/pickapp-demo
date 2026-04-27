import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../../../../core/widgets/pickup_error_state.dart';
import '../../../../core/widgets/pickup_shimmer.dart';
import '../bloc/activity_cubit.dart';
import '../widgets/order_card.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: PickupAppBar(
            title: 'Aktivitas',
            showBack: false,
            bottomBorder: true,
            bottom: _TabBar(
              selectedIndex: state.selectedTab,
              ongoingCount: state.ongoingOrders.length,
              onChanged: (i) => context.read<ActivityCubit>().switchTab(i),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ActivityState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const _ActivityLoading();
    }

    if (state.hasError && state.orders.isEmpty) {
      return PickupErrorState(
        title: 'Gagal memuat pesanan',
        message: state.errorMessage!,
        onRetry: () => context.read<ActivityCubit>().loadOrders(),
      );
    }

    final orders =
        state.selectedTab == 0 ? state.ongoingOrders : state.completedOrders;

    if (orders.isEmpty) {
      return PickupEmptyState(
        title: state.selectedTab == 0
            ? 'Tidak ada pesanan aktif'
            : 'Belum ada riwayat',
        message: state.selectedTab == 0
            ? 'Pesanan yang sedang berjalan akan muncul di sini.'
            : 'Riwayat pesanan yang telah selesai atau dibatalkan.',
        icon: state.selectedTab == 0
            ? Icons.delivery_dining_outlined
            : Icons.history,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ActivityCubit>().refreshOrders(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.base),
        itemCount: orders.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onTap: () => context.push(RouteNames.orderDetail, extra: order),
          );
        },
      ),
    );
  }
}

class _TabBar extends StatelessWidget implements PreferredSizeWidget {
  const _TabBar({
    required this.selectedIndex,
    required this.ongoingCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int ongoingCount;
  final ValueChanged<int> onChanged;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        children: [
          _Tab(
            label: 'Berlangsung',
            badge: ongoingCount > 0 ? '$ongoingCount' : null,
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: AppSpacing.lg),
          _Tab(
            label: 'Riwayat',
            isSelected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              width: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityLoading extends StatelessWidget {
  const _ActivityLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: PickupListShimmer(
        itemCount: 4,
        itemBuilder: (context, index) => const PickupShimmerBox(
          height: 140,
          radius: AppRadius.lg,
        ),
      ),
    );
  }
}
