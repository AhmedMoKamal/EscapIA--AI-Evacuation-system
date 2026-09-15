import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/core/utils/zone_safety_helper.dart';
import 'package:escapia/features/live_map/presentation/widgets/live_map_canvas.dart';
import 'package:escapia/features/live_map/presentation/widgets/live_map_controls.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_cubit.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapCard extends StatefulWidget {
  final List<ZoneEntity>? zones;
  final void Function(String zoneId)? onZoneTap;

  const MapCard({super.key, this.zones, this.onZoneTap});

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  bool _showDistances = true;
  double _zoomScale = 0.55;
  bool _isScaleAutoCalculated = false;

  Widget _buildLiveMapCanvas(List<ZoneEntity> zones) {
    final activeRoutes = ZoneSafetyHelper.findAllSafeRoutes(zones);

    return LiveMapCanvas(
      zones: zones,
      safeRoutes: activeRoutes,
      showDistances: _showDistances,
      zoomScale: _zoomScale,
      onFitScaleCalculated: (fitScale) {
        if (!_isScaleAutoCalculated) {
          setState(() {
            _zoomScale = fitScale;
            _isScaleAutoCalculated = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool hasBoundedHeight =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0;

        final double fallbackHeight = context.space(
          context.isMobile ? 350.0 : 480.0,
        );

        return Container(
          height: hasBoundedHeight ? null : fallbackHeight,
          padding: EdgeInsets.all(context.space(context.isMobile ? 12 : 16)),
          decoration: BoxDecoration(
            color: AppColors.statCardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Building Map: Level 1',
                style: AppTextStyles.font16W700Primary,
              ),
              SizedBox(height: context.space(context.isMobile ? 8 : 12)),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.blackOverlay40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: widget.zones != null
                              ? _buildLiveMapCanvas(widget.zones!)
                              : BlocBuilder<
                                  BuildingStateCubit,
                                  BuildingStateState
                                >(
                                  builder: (context, state) {
                                    if (state is BuildingStateLoaded) {
                                      return _buildLiveMapCanvas(state.zones);
                                    }
                                    if (state is BuildingStateError) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context.space(16),
                                          ),
                                          child: Text(
                                            state.error.message,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.font14W400Red,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.brightCyan,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Positioned(
                          right: context.space(context.isMobile ? 10 : 16),
                          bottom: context.space(context.isMobile ? 10 : 16),
                          child: LiveMapControls(
                            showDistances: _showDistances,
                            onToggleDistances: () {
                              setState(() => _showDistances = !_showDistances);
                            },
                            onZoomIn: () {
                              setState(
                                () => _zoomScale = (_zoomScale + 0.15).clamp(
                                  0.2,
                                  2.5,
                                ),
                              );
                            },
                            onZoomOut: () {
                              setState(
                                () => _zoomScale = (_zoomScale - 0.15).clamp(
                                  0.2,
                                  2.5,
                                ),
                              );
                            },
                            onZoomReset: () {
                              setState(() => _zoomScale = 1.0);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
