import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_cubit.dart';
import 'package:escapia/features/incidents/presentation/widgets/incident_report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewDetailsButton extends StatelessWidget {
  final String incidentId;

  const ViewDetailsButton({
    super.key,
    required this.incidentId,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierColor: AppColors.blackOverlay70,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<ReportCubit>(),
            child: IncidentReportDialog(incidentId: incidentId),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        side: const BorderSide(color: AppColors.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: AppColors.whiteOverlayFaint,
      ),
      child: const Text(
        'View Details',
        style: AppTextStyles.font12W500LightSlate,
      ),
    );
  }
}