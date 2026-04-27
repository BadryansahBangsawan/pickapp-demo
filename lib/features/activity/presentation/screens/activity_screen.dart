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
import '../../../chat/presentation/models/chat_models.dart';
import '../bloc/activity_cubit.dart';
import '../models/activity_models.dart';
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

    final orders = state.selectedTab == 0
        ? state.ongoingOrders
        : state.completedOrders;

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
            onChat: order.isOngoing && order.driverName != null
                ? () => _onChat(context, order)
                : null,
            onCancel: order.isOngoing ? () => _onCancel(context, order) : null,
            onComplete: order.isOngoing
                ? () => _onComplete(context, order)
                : null,
            onReorder: order.status == OrderStatus.completed
                ? () => _onReorder(context, order)
                : null,
          );
        },
      ),
    );
  }

  void _onChat(BuildContext context, OrderItem order) {
    final thread = _resolveChatThread(order);
    if (thread != null) {
      context.push(RouteNames.chatRoom, extra: thread);
    } else {
      context.push(RouteNames.chat);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          thread != null
              ? 'Membuka chat ${thread.name}...'
              : 'Membuka daftar chat...',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  ChatThread? _resolveChatThread(OrderItem order) {
    final threads = buildMockChatThreads();

    if (order.serviceType == OrderServiceType.food) {
      final lowerTitle = order.title.toLowerCase();
      if (lowerTitle.contains('warung bu tini')) {
        return _findThreadById(threads, 'food-warung-bu-tini');
      }
      return _findThreadById(threads, 'support');
    }

    if (order.serviceType == OrderServiceType.ride &&
        (order.driverName ?? '').isNotEmpty) {
      return _findThreadById(threads, 'driver-rizky') ??
          _findThreadById(threads, 'support');
    }

    return _findThreadById(threads, 'support');
  }

  ChatThread? _findThreadById(List<ChatThread> threads, String threadId) {
    for (final thread in threads) {
      if (thread.id == threadId) return thread;
    }
    return null;
  }

  void _onCancel(BuildContext context, OrderItem order) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: Text('Apakah kamu yakin ingin membatalkan ${order.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<ActivityCubit>().cancelOrder(order.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan dibatalkan.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
  }

  void _onComplete(BuildContext context, OrderItem order) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Selesaikan Pesanan?'),
        content: Text('Tandai ${order.title} sebagai selesai?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Ya, Selesai'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<ActivityCubit>().completeOrder(order.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan selesai!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _onReorder(BuildContext context, OrderItem order) {
    switch (order.serviceType) {
      case OrderServiceType.ride:
        context.push(RouteNames.pickLocation);
      case OrderServiceType.food:
        context.push(RouteNames.foodHome);
      case OrderServiceType.send:
        context.push(RouteNames.sendPackage);
    }
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
        itemBuilder: (context, index) =>
            const PickupShimmerBox(height: 140, radius: AppRadius.lg),
      ),
    );
  }
}
