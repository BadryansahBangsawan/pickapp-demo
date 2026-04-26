import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class PickupShimmerBox extends StatelessWidget {
  const PickupShimmerBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.radius = AppRadius.sm,
    this.margin = EdgeInsets.zero,
  });

  final double height;
  final double width;
  final double radius;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: Colors.white,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}

class PickupListShimmer extends StatelessWidget {
  const PickupListShimmer({
    super.key,
    this.itemCount = 6,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.base),
      itemBuilder: itemBuilder,
    );
  }
}
