import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class IncidentBannerHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const IncidentBannerHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: context.space(8)),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16W700.copyWith(
              color: color,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}