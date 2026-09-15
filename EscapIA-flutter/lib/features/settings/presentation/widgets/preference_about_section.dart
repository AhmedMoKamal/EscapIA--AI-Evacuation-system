import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class PreferenceAboutSection extends StatelessWidget {
  const PreferenceAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.space(18)),
      child: Column(
        children: [
          const Text(
            'About',
            style: AppTextStyles.font14W700Primary,
          ),
          SizedBox(height: context.space(4)),
          const Text(
            'ESCAPIA v1.0.0',
            style: AppTextStyles.font14W400White54,
          ),
          SizedBox(height: context.space(6)),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Contact Support',
                  style: AppTextStyles.font15W400RouteBlue,
                ),
                SizedBox(width: context.space(4)),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: AppColors.routeBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
