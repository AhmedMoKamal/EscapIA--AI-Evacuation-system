import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadiusValue = context.space(12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font16W400White70.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: context.space(8)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: AppColors.textPrimary,
          style: AppTextStyles.font15W400Primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.font15W400Primary.copyWith(
              color: AppColors.textSecondary,
            ),
            errorStyle: AppTextStyles.font12W400Secondary.copyWith(
              color: AppColors.errorRed,
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.space(16),
              vertical: context.space(16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              borderSide: const BorderSide(
                color: AppColors.routeBlue,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              borderSide: const BorderSide(
                color: AppColors.errorRed,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}