import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/core/widgets/custom_error_widget.dart';
import 'package:escapia/core/utils/zone_safety_helper.dart';
import 'package:escapia/features/live_map/presentation/pages/Live_map_web_layout.dart';
import 'package:escapia/features/live_map/presentation/pages/live_map_mobile_layout.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_cubit.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveMap extends StatefulWidget {
  const LiveMap({super.key});

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  bool _showDistances = true;
  double _zoomScale = 1.0;

  @override
  void initState() {
    super.initState();
    context.read<BuildingStateCubit>().initBuildingState();
  }

  void _onFitScaleCalculated(double fitScale) {
    setState(() => _zoomScale = fitScale);
  }

  void _onToggleDistances() {
    setState(() => _showDistances = !_showDistances);
  }

  void _onZoomIn() {
    setState(() => _zoomScale = (_zoomScale + 0.15).clamp(0.2, 2.5));
  }

  void _onZoomOut() {
    setState(() => _zoomScale = (_zoomScale - 0.15).clamp(0.2, 2.5));
  }

  void _onZoomReset() {
    setState(() => _zoomScale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BuildingStateCubit, BuildingStateState>(
        builder: (context, state) {
          if (state is BuildingStateLoading || state is BuildingStateInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brightCyan),
            );
          }
          if (state is BuildingStateError) {
            return CustomErrorWidget(
              error: state.error,
              onRetry: () {
                context.read<BuildingStateCubit>().initBuildingState();
              },
            );
          }
          final zones = (state as BuildingStateLoaded).zones;
          final activeRoutes = ZoneSafetyHelper.findAllSafeRoutes(zones);

          if (context.isMobile) {
            return LiveMapMobileLayout(
              zones: zones,
              safeRoutes: activeRoutes,
              showDistances: _showDistances,
              zoomScale: _zoomScale,
              onFitScaleCalculated: _onFitScaleCalculated,
              onToggleDistances: _onToggleDistances,
              onZoomIn: _onZoomIn,
              onZoomOut: _onZoomOut,
              onZoomReset: _onZoomReset,
            );
          }
          return LiveMapWebLayout(
            zones: zones,
            safeRoutes: activeRoutes,
            showDistances: _showDistances,
            zoomScale: _zoomScale,
            onFitScaleCalculated: _onFitScaleCalculated,
            onToggleDistances: _onToggleDistances,
            onZoomIn: _onZoomIn,
            onZoomOut: _onZoomOut,
            onZoomReset: _onZoomReset,
          );
        },
      ),
    );
  }
}