import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class InstructionBox extends StatelessWidget {
  final String text;

  const InstructionBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.space(10)),
      decoration: BoxDecoration(
        color: AppColors.instructionBoxBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTextStyles.font12W400Primary,
      ),
    );
  }
}