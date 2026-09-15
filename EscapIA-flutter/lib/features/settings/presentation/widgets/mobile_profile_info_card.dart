import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/settings/presentation/widgets/info_field.dart';
import 'package:flutter/material.dart';

class MobileProfileInfoCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String role;
  const MobileProfileInfoCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmall = context.isSmallMobile;
    final double avatarRadius = context.space(isSmall ? 38.0 : 44.0);
    final double cardPadding = context.space(isSmall ? 16.0 : 22.0);
    final double sectionSpacing = context.space(isSmall ? 16.0 : 20.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.statCardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      padding: EdgeInsets.all(cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.coolSlateSurface,
                  child: Icon(
                    Icons.person_rounded,
                    size:
                        avatarRadius * 1.1,
                    color: AppColors
                        .textSecondary, 
                  ),
                ),
                SizedBox(height: context.space(12)),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderMedium),
                    foregroundColor: AppColors.textPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.space(20),
                      vertical: context.space(10),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Change Photo',
                    style: AppTextStyles.font14W500Primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.space(isSmall ? 20 : 26)),
          InfoField(label: 'Name', value: name),
          SizedBox(height: sectionSpacing),
          InfoField(
            label: 'Phone Number',
            value: phoneNumber,
            helperText:
                'Critical and warning alerts are always sent via SMS to this number and cannot be disabled.',
          ),
          SizedBox(height: sectionSpacing),
          SizedBox(height: sectionSpacing),
          InfoField(label: 'Role', value: role),
        ],
      ),
    );
  }
}
