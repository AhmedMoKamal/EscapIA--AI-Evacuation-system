import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class PreferenceTile extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Widget? customContent;
  final bool showBottomBorder;
  final VoidCallback? onTap;

  const PreferenceTile({
    super.key,
    this.title,
    this.trailing,
    this.customContent,
    this.showBottomBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.space(16),
          vertical: context.space(12),
        ),
        decoration: BoxDecoration(
          border: showBottomBorder
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.coolSlateSurface,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: customContent ??
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTextStyles.font14W400Secondary,
                  ),
                if (trailing != null) trailing!,
              ],
            ),
      ),
    );
  }
}