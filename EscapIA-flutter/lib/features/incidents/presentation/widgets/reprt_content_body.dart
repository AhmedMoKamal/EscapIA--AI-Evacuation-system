import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/core/widgets/custom_error_widget.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_cubit.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_state.dart';
import 'package:escapia/features/incidents/presentation/widgets/markdown_report_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportContentBody extends StatelessWidget {
  final String incidentId;

  const ReportContentBody({required this.incidentId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.brightCyan,
            ),
          );
        }

        if (state is ReportError) {
          return CustomErrorWidget(
            error: state.error,
            onRetry: () {
              context.read<ReportCubit>().getIncidentReport(incidentId);
            },
          );
        }

        if (state is ReportSuccess) {
          final rawText = state.report.content;

          if (rawText.isEmpty) {
            return Center(
              child: Text(
                'No report available',
                style: AppTextStyles.font16W400White70.copyWith(
                  fontSize: context.space(16),
                ),
              ),
            );
          }

          return MarkdownReportView(rawText: rawText);
        }

        return const SizedBox.shrink();
      },
    );
  }
}