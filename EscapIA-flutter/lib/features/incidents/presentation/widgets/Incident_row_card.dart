import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/date_time_formatter.dart';
import 'package:escapia/features/incidents/presentation/widgets/view_details_button.dart';
import 'package:flutter/material.dart';

class IncidentRowCard extends StatelessWidget {
  final String incidentId;
  final String startAt;
  final String endAt;
  final String status;

  const IncidentRowCard({
    super.key,
    required this.incidentId,
    required this.startAt,
    required this.endAt,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkBlueGray.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderFaint),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              incidentId,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font13W400SlateGray,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DateTimeFormatter.formatDateTime(startAt),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font13W400SlateGray,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DateTimeFormatter.formatDateTime(endAt),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font13W400SlateGray,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font13W400SlateGray,
            ),
          ),
          SizedBox(
            width: 105,
            child: ViewDetailsButton(incidentId: incidentId),
          ),
        ],
      ),
    );
  }
}
