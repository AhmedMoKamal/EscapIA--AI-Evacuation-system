import 'package:escapia/core/utils/responsive_helper.dart';
import 'package:escapia/core/widgets/custom_error_widget.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_cubit.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_state.dart';
import 'package:escapia/features/overview/presentation/pages/Overview_mobile_layout.dart';
import 'package:escapia/features/overview/presentation/pages/Overview_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void initState() {
    super.initState();
    context.read<BuildingStateCubit>().initBuildingState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuildingStateCubit, BuildingStateState>(
      builder: (context, state) {
        if (state is BuildingStateLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BuildingStateError) {
          return CustomErrorWidget(
            error: state.error,
            onRetry: () {
              context.read<BuildingStateCubit>().initBuildingState();
            },
          );
        }
        if (state is BuildingStateLoaded) {
          final zones = state.zones;
          return ResponsiveLayout(
            mobileBody: OverviewMobileLayout(data: zones),
            webBody: OverviewWebLayout(data: zones),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
