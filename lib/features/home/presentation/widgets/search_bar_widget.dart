import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.searchFill,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            children: const [
              Icon(Icons.search, size: 20, color: AppColors.textHint),
              SizedBox(width: AppSpacing.md),
              Text(
                'Mau kemana?',
                style: TextStyle(fontSize: 16, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
