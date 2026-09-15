import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/features/incidents/presentation/widgets/header_item.dart';
import 'package:flutter/material.dart';

class IncidentTableHeader extends StatelessWidget {
  const IncidentTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.slateBackground.withOpacity(0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderHairline),
      ),
      child: Row(
        children: [
          HeaderItem(title: 'Incident ID', flex: 2),
          HeaderItem(title: 'Started At', flex: 2),
          HeaderItem(title: 'Ended At', flex: 2),
          HeaderItem(title: 'status', flex: 2),
          const SizedBox(width: 105),
        ],
      ),
    );
  }
}
