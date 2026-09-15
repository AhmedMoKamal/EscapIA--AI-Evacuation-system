import 'dart:math' as math;
import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/constants/mall_map_constants.dart';
import 'package:escapia/core/utils/zone_safety_helper.dart';
import 'package:escapia/features/live_map/data/models/edge_connection_model.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:flutter/material.dart';
part 'mall_map_painter_hazard.dart';
part 'mall_map_painter_routes.dart';
part 'mall_map_painter_ui.dart';

enum ZoneHazardType { none, fire, smoke }

class MallMapPainter extends CustomPainter {
  final List<ZoneEntity> zones;
  final List<List<String>> safeRoutes;
  final double animProgress;
  final bool showDistances;
  final double zoomScale;

  MallMapPainter({
    required this.zones,
    required this.safeRoutes,
    required this.animProgress,
    required this.showDistances,
    required this.zoomScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(zoomScale);

    final unscaledSize = Size(size.width / zoomScale, size.height / zoomScale);

    _drawBackgroundGrid(canvas, unscaledSize);
    _drawEdges(canvas);
    _drawZoneCards(canvas);
    _drawDangerRadarWaves(canvas);
    _drawZoneLabelsAndIcons(canvas);

    canvas.restore();
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.slateBackground.withOpacity(0.25)
      ..strokeWidth = 1.0;

    const double step = 40.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final borderPaint = Paint()
      ..color = AppColors.steelBlueGray.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MallMapPainter oldDelegate) => true;
}
