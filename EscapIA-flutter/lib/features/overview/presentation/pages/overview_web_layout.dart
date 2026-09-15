import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/active_incidents_card.dart';
import 'package:escapia/features/overview/presentation/widgets/map_card.dart';
import 'package:escapia/features/overview/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class OverviewWebLayout extends StatelessWidget {
  final List<ZoneEntity> data;

  const OverviewWebLayout({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    int totalPeople = 0, safeExits = 0, totalExits = 0;
    for (final z in data) {
      totalPeople += z.peopleCount;
      if (z.safeExitsCount > safeExits) safeExits = z.safeExitsCount;
      if (z.totalExits > totalExits) totalExits = z.totalExits;
    }

    final int activeIncidents = data
        .where((z) => z.fireDetected || z.smokeDetected)
        .length;
    final bool hasFire = data.any((z) => z.fireDetected == true);
    final bool hasSmoke = data.any((z) => z.smokeDetected == true);

    String mallStatusText;
    Color mallStatusColor;
    IconData mallStatusIcon;
    String? riskLevel;

    if (hasFire) {
      mallStatusText = 'Fire';
      mallStatusColor = AppColors.criticalCrimson;
      mallStatusIcon = Icons.local_fire_department_rounded;
      // جلب الريسك الخاص بمنطقة الحريق من الباك
      riskLevel = data.firstWhere((z) => z.fireDetected).riskLevel;
    } else if (hasSmoke) {
      mallStatusText = 'Smoke';
      mallStatusColor = AppColors.warningAmber;
      mallStatusIcon = Icons.cloud_outlined;
      // جلب الريسك الخاص بمنطقة الدخان من الباك
      riskLevel = data.firstWhere((z) => z.smokeDetected).riskLevel;
    } else {
      mallStatusText = 'Normal';
      mallStatusColor = AppColors.successEmerald80;
      mallStatusIcon = Icons.shield_outlined;
      riskLevel = null;
    }

    final statCards = [
      StatCard(
        icon: mallStatusIcon,
        title: 'Mall Status',
        value: mallStatusText,
        riskLevel: riskLevel, // تمرير الريسك القادم من الباك
        valueColor: mallStatusColor,
        borderColor: mallStatusColor,
        backgroundColor: mallStatusColor.withOpacity(0.12),
      ),
      StatCard(
        icon: Icons.warning_amber_outlined,
        title: 'Active Incidents',
        value: '$activeIncidents',
        valueColor: activeIncidents > 0
            ? AppColors.warningAmber
            : AppColors.textPrimary,
        borderColor: activeIncidents > 0
            ? AppColors.warningAmber
            : AppColors.cardBorder,
        backgroundColor: activeIncidents > 0
            ? AppColors.warningAmber.withOpacity(0.12)
            : AppColors.cardBackground,
      ),
      StatCard(
        icon: Icons.arrow_forward,
        title: 'Safe Exits',
        value: '$safeExits/2',
      ),
      StatCard(
        icon: Icons.person_outline,
        title: 'People in Mall',
        value: '$totalPeople',
      ),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.space(24.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (int i = 0; i < statCards.length; i++) ...[
                Expanded(child: statCards[i]),
                if (i < statCards.length - 1)
                  SizedBox(width: context.space(16)),
              ],
            ],
          ),
          SizedBox(height: context.space(24)),
          SizedBox(
            height: context.space(500),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 7, child: MapCard(zones: data)),
                SizedBox(width: context.space(20)),
                Expanded(flex: 3, child: ActiveIncidentsPanel(zones: data)),
              ],
            ),
          ),
          SizedBox(height: context.space(24)),
        ],
      ),
    );
  }
}