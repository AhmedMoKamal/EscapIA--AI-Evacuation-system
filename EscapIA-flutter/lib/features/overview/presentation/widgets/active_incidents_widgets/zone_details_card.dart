import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/active_incidents_card.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/ai_reccomendation_card.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/incident_detail_row.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/view_report_button.dart';
import 'package:flutter/material.dart';

class ZoneDetailsCard extends StatelessWidget {
  final ZoneEntity activeZone;
  final IncidentState incidentState;
  final Color statusColor;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback? onViewReport;

  const ZoneDetailsCard({
    super.key,
    required this.activeZone,
    required this.incidentState,
    required this.statusColor,
    required this.isExpanded,
    required this.onToggleExpand,
    this.onViewReport,
  });

  String formatIncidentDuration(DateTime startAt, DateTime? endAt) {
    final endTime = endAt ?? DateTime.now();
    final difference = endTime.difference(startAt);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '$hours hr $minutes min';
    } else {
      final mins = difference.inMinutes > 0 ? difference.inMinutes : 1;
      return '$mins min';
    }
  }

  String formatIncidentTimeSummary(DateTime startAt, DateTime? endAt) {
    final startTimeStr =
        '${startAt.hour.toString().padLeft(2, '0')}:${startAt.minute.toString().padLeft(2, '0')}';

    if (endAt == null) {
      final duration = formatIncidentDuration(startAt, null);
      return 'Started at $startTimeStr (Active for $duration)';
    }
    final endTimeStr =
        '${endAt.hour.toString().padLeft(2, '0')}:${endAt.minute.toString().padLeft(2, '0')}';
    final duration = formatIncidentDuration(startAt, endAt);

    return '$startTimeStr - $endTimeStr ($duration)';
  }

  Color _getRiskColor(String risk) {
    switch (risk.trim().toLowerCase()) {
      case 'critical':
      case 'high':
      case 'danger':
        return AppColors.vividRed;
      case 'medium':
      case 'warning':
        return AppColors.warningAmber;
      case 'low':
      default:
        return AppColors.successEmerald80;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.25), width: 1),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.space(10),
        vertical: context.space(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onToggleExpand,
            child: Row(
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
                SizedBox(width: context.space(4)),
                Expanded(
                  child: Text(
                    activeZone.zoneId.toUpperCase(),
                    style: AppTextStyles.font14W700Primary,
                  ),
                ),
              ],
            ),
          ),
          if (incidentState == IncidentState.resolved) ...[
            SizedBox(height: context.space(8)),
            ViewReportButton(onPressed: onViewReport),
          ],
          if (isExpanded && incidentState != IncidentState.resolved) ...[
            SizedBox(height: context.space(8)),
            Row(
              children: [
                Expanded(
                  child: IncidentDetailRow(
                    label: 'People:',
                    value: '${activeZone.peopleCount}',
                  ),
                ),
                SizedBox(width: context.space(8)),
                Expanded(
                  child: IncidentDetailRow(
                    label: 'Risk:',
                    value: activeZone.riskLevel,
                    valueColor: _getRiskColor(activeZone.riskLevel),
                  ),
                ),
              ],
            ),
            if (activeZone.instruction.isNotEmpty ||
                activeZone.fullRoute.isNotEmpty) ...[
              SizedBox(height: context.space(8)),
              AiRecommendationCard(zone: activeZone),
            ],
          ],
        ],
      ),
    );
  }
}
