import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.space(height),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.richBlackBackground,
          disabledBackgroundColor: AppColors.richBlackBackground.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.space(12)),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: context.space(22),
                height: context.space(22),
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.textPrimary,
                ),
              )
            : Text(
                label,
                style: AppTextStyles.font16W700Primary,
              ),
      ),
    );
  }
}