import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/errors/error_handler.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  IconData _getIcon() {
    switch (error.type) {
      case ErrorType.noInternet:
        return Icons.wifi_off_rounded;
      case ErrorType.serverUnavailable:
      case ErrorType.unknown:
        return Icons.cloud_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.space(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: context.space(64),
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: context.space(20)),
            Text(
              error.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font18W700Primary.copyWith(
                fontSize: context.space(20),
              ),
            ),
            SizedBox(height: context.space(8)),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14W500Primary.copyWith(
                fontSize: context.space(14),
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: context.space(24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.slateBackground,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(24),
                  vertical: context.space(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.space(8)),
                  side: const BorderSide(
                    color: AppColors.borderSubtle,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'Retry Now',
                style: AppTextStyles.font15W700Primary.copyWith(
                  fontSize: context.space(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}