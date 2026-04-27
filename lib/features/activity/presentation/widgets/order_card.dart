import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../models/activity_models.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});

  final OrderItem order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PickupCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _serviceColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Icon(_serviceIcon, size: 20, color: _serviceColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.small,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Formatters.currency(order.amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatusBadge(status: order.status),
              const Spacer(),
              Text(
                Formatters.relative(order.createdAt),
                style: AppTypography.small,
              ),
            ],
          ),
          if (order.driverName != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Image.network(
                    order.driverPhoto ?? '',
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 28,
                      height: 28,
                      color: AppColors.surface,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_outline, size: 16),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    order.driverName!,
                    style: AppTypography.caption.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (order.rating != null) ...[
                  const Icon(Icons.star, size: 14, color: AppColors.amber),
                  const SizedBox(width: 2),
                  Text(
                    order.rating!.toStringAsFixed(1),
                    style: AppTypography.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData get _serviceIcon {
    switch (order.serviceType) {
      case OrderServiceType.ride:
        return Icons.two_wheeler_outlined;
      case OrderServiceType.food:
        return Icons.restaurant_outlined;
      case OrderServiceType.send:
        return Icons.local_shipping_outlined;
    }
  }

  Color get _serviceColor {
    switch (order.serviceType) {
      case OrderServiceType.ride:
        return AppColors.primary;
      case OrderServiceType.food:
        return const Color(0xFFE91E63);
      case OrderServiceType.send:
        return AppColors.warning;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case OrderStatus.searching:
      case OrderStatus.driverFound:
      case OrderStatus.inProgress:
        bg = AppColors.badgeWarningBg;
        fg = AppColors.badgeWarningText;
      case OrderStatus.completed:
        bg = AppColors.badgeSuccessBg;
        fg = AppColors.badgeSuccessText;
      case OrderStatus.cancelled:
        bg = AppColors.badgeErrorBg;
        fg = AppColors.badgeErrorText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        status == OrderStatus.searching
            ? 'Mencari driver'
            : status == OrderStatus.driverFound
                ? 'Driver ditemukan'
                : status == OrderStatus.inProgress
                    ? 'Dalam perjalanan'
                    : status == OrderStatus.completed
                        ? 'Selesai'
                        : 'Dibatalkan',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
