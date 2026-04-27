import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'pickup_button.dart';

enum PickupErrorType { generic, network, server }

class PickupErrorState extends StatelessWidget {
  const PickupErrorState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel = 'Coba Lagi',
    this.onRetry,
    this.icon,
    this.type = PickupErrorType.generic,
  });

  factory PickupErrorState.auto({
    Key? key,
    required String message,
    String? title,
    String actionLabel = 'Coba Lagi',
    VoidCallback? onRetry,
  }) {
    final type = _detectErrorType(message);
    return PickupErrorState(
      key: key,
      title: title ?? _defaultTitle(type),
      message: message.trim().isEmpty ? _defaultMessage(type) : message,
      actionLabel: actionLabel,
      onRetry: onRetry,
      type: type,
    );
  }

  factory PickupErrorState.network({
    Key? key,
    String? title,
    String? message,
    String actionLabel = 'Coba Lagi',
    VoidCallback? onRetry,
  }) {
    return PickupErrorState(
      key: key,
      title: title ?? _defaultTitle(PickupErrorType.network),
      message: message ?? _defaultMessage(PickupErrorType.network),
      actionLabel: actionLabel,
      onRetry: onRetry,
      type: PickupErrorType.network,
    );
  }

  factory PickupErrorState.server({
    Key? key,
    String? title,
    String? message,
    String actionLabel = 'Coba Lagi',
    VoidCallback? onRetry,
  }) {
    return PickupErrorState(
      key: key,
      title: title ?? _defaultTitle(PickupErrorType.server),
      message: message ?? _defaultMessage(PickupErrorType.server),
      actionLabel: actionLabel,
      onRetry: onRetry,
      type: PickupErrorType.server,
    );
  }

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onRetry;
  final IconData? icon;
  final PickupErrorType type;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = icon ?? _defaultIcon(type);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              alignment: Alignment.center,
              child: Icon(resolvedIcon, size: 40, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(title, style: AppTypography.h3, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.base),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180),
              child: PickupButton(
                label: actionLabel,
                variant: PickupButtonVariant.secondary,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

PickupErrorType _detectErrorType(String message) {
  final value = message.toLowerCase();
  const networkKeywords = <String>[
    'internet',
    'koneksi',
    'connection',
    'network',
    'socket',
    'host lookup',
    'timeout',
    'time out',
  ];

  for (final keyword in networkKeywords) {
    if (value.contains(keyword)) {
      return PickupErrorType.network;
    }
  }

  return PickupErrorType.server;
}

String _defaultTitle(PickupErrorType type) {
  switch (type) {
    case PickupErrorType.network:
      return 'Koneksi tidak stabil';
    case PickupErrorType.server:
      return 'Server sedang bermasalah';
    case PickupErrorType.generic:
      return 'Terjadi kesalahan';
  }
}

String _defaultMessage(PickupErrorType type) {
  switch (type) {
    case PickupErrorType.network:
      return 'Periksa internet kamu lalu coba lagi.';
    case PickupErrorType.server:
      return 'Layanan sedang mengalami gangguan sementara.';
    case PickupErrorType.generic:
      return 'Silakan coba lagi dalam beberapa saat.';
  }
}

IconData _defaultIcon(PickupErrorType type) {
  switch (type) {
    case PickupErrorType.network:
      return Icons.wifi_off_rounded;
    case PickupErrorType.server:
      return Icons.cloud_off_rounded;
    case PickupErrorType.generic:
      return Icons.error_outline_rounded;
  }
}
