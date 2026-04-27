import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../models/activity_models.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PickupAppBar(title: 'Detail Pesanan #${order.id.substring(4)}'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: [
          _buildServiceHeader(),
          const SizedBox(height: AppSpacing.base),
          _buildRouteCard(),
          if (order.driverName != null) ...[
            const SizedBox(height: AppSpacing.base),
            _buildDriverCard(),
          ],
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.base),
            _buildItemsCard(),
          ],
          const SizedBox(height: AppSpacing.base),
          _buildReceiptCard(context),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildServiceHeader() {
    return PickupCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _serviceColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(_serviceIcon, size: 24, color: _serviceColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.serviceLabel, style: AppTypography.h3),
                const SizedBox(height: 2),
                Text(order.statusLabel, style: AppTypography.caption),
              ],
            ),
          ),
          _StatusChip(status: order.status),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return PickupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Perjalanan',
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(order.title, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(order.subtitle, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Formatters.dateTime(order.createdAt),
                style: AppTypography.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return PickupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver',
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Image.network(
                  order.driverPhoto ?? '',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 48,
                    height: 48,
                    color: AppColors.surface,
                    alignment: Alignment.center,
                    child: const Icon(Icons.person_outline),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.driverName!, style: AppTypography.bodyMedium),
                    if (order.vehicleInfo != null)
                      Text(order.vehicleInfo!, style: AppTypography.small),
                  ],
                ),
              ),
              if (order.rating != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 2,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.amber),
                      const SizedBox(width: 3),
                      Text(
                        order.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard() {
    return PickupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Pesanan',
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Text(
                    '${item.quantity}x',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(item.name, style: AppTypography.body)),
                  Text(
                    Formatters.currency(item.price),
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
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

  Widget _buildReceiptCard(BuildContext context) {
    int subtotal = order.amount;
    if (order.items.isNotEmpty) {
      subtotal = order.items.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );
    }
    final deliveryFee = order.amount - subtotal;

    return PickupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pembayaran',
            style: AppTypography.label.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          if (order.items.isNotEmpty) ...[
            _ReceiptRow(
              label: 'Subtotal',
              value: Formatters.currency(subtotal),
            ),
            _ReceiptRow(
              label: 'Ongkos kirim',
              value: deliveryFee > 0
                  ? Formatters.currency(deliveryFee)
                  : 'Gratis',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1),
            ),
          ],
          _ReceiptRow(
            label: 'Total',
            value: Formatters.currency(order.amount),
            isBold: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReceiptRow(label: 'Metode pembayaran', value: 'PickPay'),
          const SizedBox(height: AppSpacing.md),
          PickupButton(
            label: 'Lihat Riwayat Pembayaran',
            icon: Icons.receipt_long_outlined,
            variant: PickupButtonVariant.secondary,
            onPressed: () => context.go(RouteNames.payment),
          ),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case OrderStatus.searching:
        bg = AppColors.badgeWarningBg;
        fg = AppColors.badgeWarningText;
        label = 'Mencari';
      case OrderStatus.driverFound:
        bg = AppColors.badgeInfoBg;
        fg = AppColors.badgeInfoText;
        label = 'Driver ditemukan';
      case OrderStatus.inProgress:
        bg = AppColors.badgeWarningBg;
        fg = AppColors.badgeWarningText;
        label = 'Berlangsung';
      case OrderStatus.completed:
        bg = AppColors.badgeSuccessBg;
        fg = AppColors.badgeSuccessText;
        label = 'Selesai';
      case OrderStatus.cancelled:
        bg = AppColors.badgeErrorBg;
        fg = AppColors.badgeErrorText;
        label = 'Dibatalkan';
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
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? AppTypography.bodyMedium.copyWith(fontSize: 15)
        : AppTypography.caption;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: style.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? AppColors.textPrimary : null,
            ),
          ),
        ],
      ),
    );
  }
}
