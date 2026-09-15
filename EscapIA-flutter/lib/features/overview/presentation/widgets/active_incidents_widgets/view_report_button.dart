import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class ViewReportButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ViewReportButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successEmerald80,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: context.space(12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textPrimary,
              size: 16,
            ),
            SizedBox(width: context.space(8)),
            const Text(
              'View Incident Report',
              style: AppTextStyles.font13W600Primary,
            ),
          ],
        ),
      ),
    );
  }
}