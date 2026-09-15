import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class AboutSectionTile extends StatelessWidget {
  final String version;
  final VoidCallback onContactSupport;

  const AboutSectionTile({
    super.key,
    required this.version,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const Text(
            'About',
            style: AppTextStyles.font14W700Primary,
          ),
          const SizedBox(height: 4),
          Text(
            'ESCAPIA $version',
            style: AppTextStyles.font13W400Secondary,
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onContactSupport,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Contact Support',
                    style: AppTextStyles.font13W500RouteBlue,
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.routeBlue,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}