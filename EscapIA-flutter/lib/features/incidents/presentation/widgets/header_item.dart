import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  final String title;
  final int flex;
  const HeaderItem({super.key, required this.title, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTextStyles.font13W500MutedSlate),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: AppColors.mutedSlateText,
          ),
        ],
      ),
    );
  }
}
