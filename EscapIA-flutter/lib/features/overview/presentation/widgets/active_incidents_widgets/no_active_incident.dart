import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class NoActiveIncidentsCard extends StatelessWidget {
  const NoActiveIncidentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [
            AppColors.slateBackground,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: const Center(
        child: Text(
          'No active incidents',
          style: AppTextStyles.font14W500Primary,
        ),
      ),
    );
  }
}