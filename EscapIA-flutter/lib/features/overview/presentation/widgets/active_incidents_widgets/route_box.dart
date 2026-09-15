import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class RouteBox extends StatelessWidget {
  final List<String> routes;

  const RouteBox({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.space(8),
        vertical: context.space(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(0.35),
          width: 0.8,
        ),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(routes.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Icon(
              Icons.arrow_forward_rounded,
              size: 12,
              color: AppColors.routeBlue,
            );
          }
          final stepIndex = index ~/ 2;
          final stepNumber = (stepIndex + 1).toString().padLeft(2, '0');

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stepNumber, style: AppTextStyles.font12W400White54),
              const SizedBox(width: 4),
              Text(routes[stepIndex], style: AppTextStyles.font11W700Cyan),
            ],
          );
        }),
      ),
    );
  }
}
