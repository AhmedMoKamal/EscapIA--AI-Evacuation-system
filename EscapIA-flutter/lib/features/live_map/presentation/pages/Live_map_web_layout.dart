import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:flutter/material.dart';
import 'package:escapia/features/live_map/presentation/widgets/live_map_canvas.dart';
import 'package:escapia/features/live_map/presentation/widgets/live_map_controls.dart';

class LiveMapWebLayout extends StatelessWidget {
  final List<ZoneEntity> zones;
  final List<List<String>> safeRoutes;
  final bool showDistances;
  final double zoomScale;
  final ValueChanged<double> onFitScaleCalculated;
  final VoidCallback onToggleDistances;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomReset;

  const LiveMapWebLayout({
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
    final Size screenSize = MediaQuery.sizeOf(context);
    final double rightOffset = (screenSize.width * 0.02).clamp(18.0, 36.0);
    final double bottomOffset = (screenSize.height * 0.04).clamp(20.0, 40.0);

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
          right: rightOffset,
          bottom: bottomOffset,
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