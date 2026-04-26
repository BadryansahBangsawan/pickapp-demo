import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    required this.onCompleted,
    this.length = 6,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final int length;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      length: length,
      autoFocus: true,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 150),
      onCompleted: onCompleted,
      onChanged: (_) {},
      cursorColor: AppColors.primary,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(AppRadius.md),
        fieldHeight: 52,
        fieldWidth: 48,
        borderWidth: 1.5,
        activeColor: AppColors.primary,
        selectedColor: AppColors.primary,
        inactiveColor: AppColors.border,
        activeFillColor: AppColors.inputFill,
        selectedFillColor: AppColors.inputFill,
        inactiveFillColor: AppColors.inputFill,
      ),
      enableActiveFill: true,
    );
  }
}
