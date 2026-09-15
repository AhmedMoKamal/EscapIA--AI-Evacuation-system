import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_cubit.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportFooterActions extends StatelessWidget {
  const ReportFooterActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space(context.isMobile ? 14 : 16),
        vertical: context.space(context.isMobile ? 12 : 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.slateBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.space(16)),
          bottomRight: Radius.circular(context.space(16)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ReportCubit, ReportState>(
            builder: (context, state) {
              if (state is ReportSuccess) {
                return TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: state.report.content),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.copy,
                    color: AppColors.routeBlue,
                    size: context.space(18),
                  ),
                  label: Text(
                    'Copy',
                    style: AppTextStyles.font15W400RouteBlue.copyWith(
                      fontSize: context.space(15),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textWhite70,
              side: const BorderSide(color: AppColors.borderMedium),
              padding: EdgeInsets.symmetric(
                horizontal: context.space(20),
                vertical: context.space(12),
              ),
            ),
            child: Text(
              'Close',
              style: AppTextStyles.font15W500.copyWith(
                fontSize: context.space(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}