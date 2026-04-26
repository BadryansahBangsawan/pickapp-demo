import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../models/food_models.dart';

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({super.key, required this.item, this.onAdd, this.onTap});

  final MenuItem item;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PickupCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(width: 88, height: 88, color: AppColors.surface),
              errorWidget: (context, url, error) => Container(
                width: 88,
                height: 88,
                color: AppColors.surface,
                alignment: Alignment.center,
                child: const Icon(Icons.fastfood_outlined),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      Formatters.currency(item.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 36,
                      child: PickupButton(
                        label: 'Tambah',
                        fullWidth: false,
                        onPressed: onAdd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
