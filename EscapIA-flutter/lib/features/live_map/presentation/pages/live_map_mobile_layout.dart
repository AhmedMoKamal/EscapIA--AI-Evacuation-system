import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/live_map/presentation/widgets/live_map_canvas.dart';
import 'package:escapia/features/live_map/presentation/widgets/live_map_controls.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:flutter/material.dart';

class LiveMapMobileLayout extends StatelessWidget {
  final List<ZoneEntity> zones;
  final List<List<String>> safeRoutes;
  final bool showDistances;
  final double zoomScale;
  final ValueChanged<double> onFitScaleCalculated;
  final VoidCallback onToggleDistances;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomReset;

  const LiveMapMobileLayout({
    super.key,
    required this.zones,
    required this.safeRoutes,
    required this.showDistances,
    required this.zoomScale,
    required this.onFitScaleCalculated,
    required this.onToggleDistances,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onZoomReset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: LiveMapCanvas(
            zones: zones,
            safeRoutes: safeRoutes,
            showDistances: showDistances,
            zoomScale: zoomScale,
            onFitScaleCalculated: onFitScaleCalculated,
          ),
        ),
        Positioned(
          right: context.space(context.isSmallMobile ? 10.0 : 16.0),
          bottom: context.space(context.isSmallMobile ? 12.0 : 20.0),
          child: SafeArea(
            child: LiveMapControls(
              showDistances: showDistances,
              onToggleDistances: onToggleDistances,
              onZoomIn: onZoomIn,
              onZoomOut: onZoomOut,
              onZoomReset: onZoomReset,
            ),
          ),
        ),
      ],
    );
  }
}