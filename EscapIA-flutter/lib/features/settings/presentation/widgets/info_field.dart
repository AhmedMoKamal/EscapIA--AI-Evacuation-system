import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final String? helperText;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.font13W400White54,
        ),
        SizedBox(height: context.space(5)),
        Text(
          value,
          softWrap: true,
          style: AppTextStyles.font16W600,
        ),
        if (helperText != null) ...[
          SizedBox(height: context.space(6)),
          Text(
            helperText!,
            softWrap: true,
            style: AppTextStyles.font12W400Secondary.copyWith(
              height: 1.35,
              color: const Color(0xff8F9CAE),
            ),
          ),
        ],
      ],
    );
  }
}