import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/core/widgets/custom_error_widget.dart';
import 'package:escapia/features/incidents/presentation/cubits/incident_cubit/incidents_cubit.dart';
import 'package:escapia/features/incidents/presentation/cubits/incident_cubit/incidents_state.dart';
import 'package:escapia/features/incidents/presentation/widgets/incident_row_card.dart';
import 'package:escapia/features/incidents/presentation/widgets/incident_table_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<IncidentsCubit>().getBasicIncidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(context.space(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<IncidentsCubit, IncidentsState>(
                builder: (context, state) {
                  if (state is IncidentsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brightCyan,
                      ),
                    );
                  }
                  if (state is IncidentsError) {
                    return CustomErrorWidget(
                      error: state.error,
                      onRetry: () {
                        context.read<IncidentsCubit>().getBasicIncidents();
                      },
                    );
                  }
                  if (state is IncidentsLoaded) {
                    final displayedList = List.from(state.incidents)
                      ..sort((a, b) {
                        final timeA =
                            DateTime.tryParse(a.startAt.toString()) ??
                            DateTime(1970);
                        final timeB =
                            DateTime.tryParse(b.startAt.toString()) ??
                            DateTime(1970);
                        return timeB.compareTo(timeA);
                      });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "All",
                              style: AppTextStyles.font20W700.copyWith(
                                fontSize: context.space(20),
                              ),
                            ),
                            SizedBox(width: context.space(8)),
                            Text(
                              "(${displayedList.length})",
                              style: AppTextStyles.font16W500White70.copyWith(
                                fontSize: context.space(16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.space(16)),
                        const IncidentTableHeader(),
                        SizedBox(height: context.space(8)),
                        Expanded(
                          child: displayedList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No incidents found.',
                                    style: AppTextStyles.font14W400White70.copyWith(
                                      fontSize: context.space(14),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await context
                                        .read<IncidentsCubit>()
                                        .getBasicIncidents();
                                  },
                                  child: ListView.builder(
                                    itemCount: displayedList.length,
                                    itemBuilder: (context, index) {
                                      final item = displayedList[index];
                                      return IncidentRowCard(
                                        incidentId: item.incidentId,
                                        startAt: item.startAt,
                                        endAt: item.endAt,
                                        status: item.status,
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}