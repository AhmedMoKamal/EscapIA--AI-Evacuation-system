import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MarkdownReportView extends StatelessWidget {
  final String rawText;

  const MarkdownReportView({required this.rawText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        context.space(context.isMobile ? 14 : 20),
      ),
      child: Markdown(
        data: rawText,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: AppTextStyles.font15W400Primary.copyWith(
            fontSize: context.space(15),
          ),
          h1: AppTextStyles.font22W700RouteBlue.copyWith(
            fontSize: context.space(22),
          ),
          h2: AppTextStyles.font18W700RouteBlue.copyWith(
            fontSize: context.space(18),
          ),
          code: AppTextStyles.font14Code.copyWith(
            fontSize: context.space(14),
          ),
          codeblockDecoration: BoxDecoration(
            color: AppColors.slateBackground,
            borderRadius: BorderRadius.circular(context.space(10)),
            border: Border.all(color: AppColors.borderMedium),
          ),
          codeblockPadding: EdgeInsets.all(context.space(16)),
          listBullet: AppTextStyles.font15W400RouteBlue.copyWith(
            fontSize: context.space(15),
          ),
          tableBody: AppTextStyles.font14W500Primary.copyWith(
            fontSize: context.space(14),
          ),
          tableHead: AppTextStyles.font15W700Primary.copyWith(
            fontSize: context.space(15),
          ),
          tableBorder: TableBorder.all(
            color: AppColors.borderMedium,
            width: 1,
          ),
        ),
      ),
    );
  }
}