import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum PickupButtonVariant { primary, secondary, text }

class PickupButton extends StatelessWidget {
  const PickupButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PickupButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.enableHaptic = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final PickupButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final bool enableHaptic;

  @override
  Widget build(BuildContext context) {
    final disabled = isLoading || onPressed == null;
    final handler = disabled
        ? null
        : () {
            if (enableHaptic) {
              if (variant == PickupButtonVariant.primary) {
                HapticFeedback.mediumImpact();
              } else {
                HapticFeedback.selectionClick();
              }
            }
            onPressed?.call();
          };

    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    switch (variant) {
      case PickupButtonVariant.primary:
        return ElevatedButton(onPressed: handler, child: child);
      case PickupButtonVariant.secondary:
        return OutlinedButton(onPressed: handler, child: child);
      case PickupButtonVariant.text:
        return TextButton(
          onPressed: handler,
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          child: child,
        );
    }
  }
}
