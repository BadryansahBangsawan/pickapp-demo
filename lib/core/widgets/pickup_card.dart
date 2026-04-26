import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class PickupCard extends StatelessWidget {
  const PickupCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.base),
    this.onTap,
    this.color,
    this.radius = AppRadius.lg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final radiusGeo = BorderRadius.circular(radius);

    final inner = Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.background,
        borderRadius: radiusGeo,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return inner;

    return Material(
      color: Colors.transparent,
      borderRadius: radiusGeo,
      child: InkWell(
        onTap: onTap,
        borderRadius: radiusGeo,
        child: inner,
      ),
    );
  }
}
