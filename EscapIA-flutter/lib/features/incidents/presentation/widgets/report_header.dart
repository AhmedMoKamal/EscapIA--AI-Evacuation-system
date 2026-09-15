import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class ReportHeader extends StatelessWidget {
  final String incidentId;

  const ReportHeader({required this.incidentId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space(context.isMobile ? 16 : 20),
        vertical: context.space(context.isMobile ? 12 : 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.slateBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.space(16)),
          topRight: Radius.circular(context.space(16)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            color: AppColors.routeBlue,
            size: context.space(24),
          ),
          SizedBox(width: context.space(10)),
          Expanded(
            child: Text(
              'Incident Report - $incidentId',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.font18W700Primary.copyWith(
                fontSize: context.space(18),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: AppColors.textWhite70,
              size: context.space(20),
            ),
          ),
        ],
      ),
    );
  }
}