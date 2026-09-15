import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? riskLevel;
  final Color valueColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.riskLevel,
    this.valueColor = AppColors.textPrimary,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space(16),
        vertical: context.space(16),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        border: Border.all(
          color: borderColor ?? AppColors.borderSubtle,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: valueColor,
            size: context.space(32),
          ),
          SizedBox(width: context.space(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.font16W400White54,
                ),
                SizedBox(height: context.space(18)),
                // FittedBox يمنع الـ Overflow تماماً ويصغر النص والبادج تلقائياً عند تصغير الشاشة
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: AppTextStyles.font26W700.copyWith(
                          color: valueColor,
                        ),
                      ),
                      if (riskLevel != null && riskLevel!.isNotEmpty) ...[
                        SizedBox(width: context.space(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.space(8),
                            vertical: context.space(3),
                          ),
                          decoration: BoxDecoration(
                            color: valueColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: valueColor.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            riskLevel!,
                            style: TextStyle(
                              color: valueColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}