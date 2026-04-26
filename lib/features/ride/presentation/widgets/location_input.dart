import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class RideLocationInput extends StatelessWidget {
  const RideLocationInput({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            onChanged: onChanged,
            minLines: 1,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary),
              hintText: hint,
            ),
          ),
        ],
      ),
    );
  }
}
