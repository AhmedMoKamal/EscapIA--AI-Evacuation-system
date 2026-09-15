import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/instruction_box.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/route_box.dart';
import 'package:flutter/material.dart';

class AiRecommendationCard extends StatelessWidget {
  final ZoneEntity zone;

  const AiRecommendationCard({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.aiRecommendationBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.aiRecommendationBorder.withOpacity(0.6),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(context.space(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Recommendation',
            style: AppTextStyles.font14W700Primary.copyWith(
              color: AppColors.aiRecommendationAccent,
            ),
          ),
          if (zone.instruction.isNotEmpty) ...[
            SizedBox(height: context.space(8)),
            InstructionBox(text: zone.instruction),
          ],
          if (zone.fullRoute.isNotEmpty) ...[
            SizedBox(height: context.space(12)),
            Text(
              'Route breakdown',
              style: AppTextStyles.font11W600.copyWith(
                color: AppColors.aiRecommendationAccent,
              ),
            ),
            SizedBox(height: context.space(6)),
            RouteBox(routes: zone.fullRoute),
          ],
        ],
      ),
    );
  }
}