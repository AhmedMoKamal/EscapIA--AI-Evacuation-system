import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_cubit.dart';
import 'package:escapia/features/incidents/presentation/widgets/report_footer_actions.dart';
import 'package:escapia/features/incidents/presentation/widgets/report_header.dart';
import 'package:escapia/features/incidents/presentation/widgets/reprt_content_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncidentReportDialog extends StatefulWidget {
  final String incidentId;

  const IncidentReportDialog({
    super.key,
    required this.incidentId,
  });

  @override
  State<IncidentReportDialog> createState() => _IncidentReportDialogState();
}

class _IncidentReportDialogState extends State<IncidentReportDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ReportCubit>().getIncidentReport(widget.incidentId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.space(context.isMobile ? 16 : 24),
        vertical: context.space(context.isMobile ? 18 : 24),
      ),
      child: Container(
        width: context.dialogWidth,
        constraints: BoxConstraints(
          maxHeight: context.maxDialogHeight,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkNavyBackground,
          borderRadius: BorderRadius.circular(context.space(16)),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            ReportHeader(incidentId: widget.incidentId),
            Expanded(
              child: ReportContentBody(incidentId: widget.incidentId),
            ),
            const ReportFooterActions(),
          ],
        ),
      ),
    );
  }
}