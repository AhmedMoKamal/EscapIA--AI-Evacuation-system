import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/settings/presentation/widgets/info_field.dart';
import 'package:flutter/material.dart';

class WebProfileInfoCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String role;

  const WebProfileInfoCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1E2735),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff364355), width: 1),
      ),
      padding: EdgeInsets.all(context.space(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Profile Information',
            style: AppTextStyles.font18W700Primary,
          ),

          SizedBox(height: context.space(26)),

          Center(
            child: CircleAvatar(
              radius: context.space(44),
              backgroundColor: AppColors.coolSlateSurface,
              child: Icon(
                size: 40,
                Icons.person_outline_rounded,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          SizedBox(height: context.space(32)),

          InfoField(label: 'Name', value: name),
          SizedBox(height: context.space(20)),

          InfoField(label: 'Phone Number', value: phoneNumber),
          SizedBox(height: context.space(20)),

          InfoField(label: 'Role', value: role),

          SizedBox(height: context.space(48)),

          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xff171E29),
                side: const BorderSide(color: Color(0xff343A43)),
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(16),
                  vertical: context.space(10),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Log Out',
                style: AppTextStyles.font13W500Primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
