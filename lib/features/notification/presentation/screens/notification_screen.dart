import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../../../../core/widgets/pickup_error_state.dart';
import '../../../../core/widgets/pickup_shimmer.dart';
import '../bloc/notification_cubit.dart';
import '../models/notification_models.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PickupAppBar(
        title: 'Notifikasi',
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationCubit>().markAllAsRead(),
                child: const Text(
                  'Baca Semua',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading && state.notifications.isEmpty) {
            return const _NotifLoading();
          }

          if (state.hasError && state.notifications.isEmpty) {
            return PickupErrorState.auto(
              title: 'Gagal memuat notifikasi',
              message: state.errorMessage!,
              onRetry: () =>
                  context.read<NotificationCubit>().loadNotifications(),
            );
          }

          if (state.notifications.isEmpty) {
            return const PickupEmptyState(
              title: 'Belum ada notifikasi',
              message:
                  'Pemberitahuan pesanan, promo, dan info penting akan muncul di sini.',
              icon: Icons.notifications_none,
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationCubit>().refreshNotifications(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: AppSpacing.base + 40 + AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return _NotificationTile(
                  notification: notif,
                  onTap: () {
                    context.read<NotificationCubit>().markAsRead(notif.id);
                    if (notif.deepLink != null) {
                      context.go(notif.deepLink!);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead
            ? null
            : AppColors.primary.withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              alignment: Alignment.center,
              child: Icon(_icon, size: 20, color: _iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.small.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.relative(notification.createdAt),
                    style: AppTypography.small.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.order:
        return Icons.delivery_dining_outlined;
      case NotificationType.promo:
        return Icons.local_offer_outlined;
      case NotificationType.payment:
        return Icons.account_balance_wallet_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.order:
        return AppColors.primary;
      case NotificationType.promo:
        return const Color(0xFFE91E63);
      case NotificationType.payment:
        return AppColors.badgeInfoText;
      case NotificationType.system:
        return AppColors.textSecondary;
    }
  }

  Color get _iconBg {
    switch (notification.type) {
      case NotificationType.order:
        return AppColors.badgeSuccessBg;
      case NotificationType.promo:
        return const Color(0xFFFCE4EC);
      case NotificationType.payment:
        return AppColors.badgeInfoBg;
      case NotificationType.system:
        return AppColors.surface;
    }
  }
}

class _NotifLoading extends StatelessWidget {
  const _NotifLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: PickupListShimmer(
        itemBuilder: (context, index) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            PickupShimmerBox(height: 40, width: 40, radius: AppRadius.sm),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickupShimmerBox(height: 14, width: 200),
                  SizedBox(height: AppSpacing.sm),
                  PickupShimmerBox(height: 12, width: double.infinity),
                  SizedBox(height: AppSpacing.xs),
                  PickupShimmerBox(height: 12, width: 160),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
