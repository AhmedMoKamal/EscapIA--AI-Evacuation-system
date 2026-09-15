part of 'custom_map_painter.dart';

extension MallMapPainterRoutes on MallMapPainter {
  int _getEdgeRouteDirection(EdgeConnection edge) {
    final edgeFrom = ZoneSafetyHelper.normalizeNode(edge.from);
    final edgeTo = ZoneSafetyHelper.normalizeNode(edge.to);

    for (final route in safeRoutes) {
      if (route.length < 2) continue;

      for (int i = 0; i < route.length - 1; i++) {
        final rFrom = ZoneSafetyHelper.normalizeNode(route[i]);
        final rTo = ZoneSafetyHelper.normalizeNode(route[i + 1]);

        if (edgeFrom == rFrom && edgeTo == rTo) return 1;
        if (edgeFrom == rTo && edgeTo == rFrom) return -1;
      }
    }

    return 0;
  }

  void _drawEdges(Canvas canvas) {
    for (final edge in MallMapConstants.edges) {
      final rawPts = MallMapConstants.pathMap[edge.id];

      if (rawPts == null || rawPts.length < 2) continue;

      final int routeDirection =
          _getEdgeRouteDirection(edge);

      final bool isSafe = routeDirection != 0;

      final List<Offset> pts =
          (routeDirection == -1) ? rawPts.reversed.toList() : rawPts;

      final path = Path()
        ..moveTo(pts[0].dx, pts[0].dy);

      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }

      if (isSafe) {
        final pulseVal =
            (math.sin(animProgress * 2 * math.pi) + 1) / 2;

        final glowColor =
            AppColors.brightCyan.withOpacity(
          0.35 + (0.25 * pulseVal),
        );

        canvas.drawPath(
          path,
          Paint()
            ..color = glowColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10.0
            ..maskFilter =
                const MaskFilter.blur(BlurStyle.normal, 8)
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );

        final blueLinePaint = Paint()
          ..color = AppColors.brightCyan
          ..strokeWidth = 4.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        _drawAnimatedDashedPath(
          canvas,
          path,
          blueLinePaint,
          dashLength: 12.0,
          gapLength: 6.0,
          phaseOffset: animProgress * 18.0,
        );

        if (showDistances) {
          final bOffset =
              MallMapConstants.badgeOffsets[edge.id] ??
                  pts[pts.length ~/ 2];

          _drawGlowingDistanceBadge(
            canvas,
            bOffset,
            '${edge.weight}m',
          );
        }
      } else {
        final normalLinePaint = Paint()
          ..color = AppColors.mutedSlateLine
          ..strokeWidth = 2.4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        _drawStaticDashedPath(
          canvas,
          path,
          normalLinePaint,
          dashLength: 8.0,
          gapLength: 6.0,
        );

        if (showDistances) {
          final bOffset =
              MallMapConstants.badgeOffsets[edge.id] ??
                  pts[pts.length ~/ 2];

          _drawDistanceBadge(
            canvas,
            bOffset,
            '${edge.weight}m',
          );
        }
      }
    }
  }

  void _drawAnimatedDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLength,
    required double gapLength,
    required double phaseOffset,
  }) {
    final pattern = dashLength + gapLength;

    for (final metric in path.computeMetrics()) {
      double distance = phaseOffset % pattern;

      if (distance > 0) {
        final initialLen = math.min(
          dashLength - (pattern - distance),
          metric.length,
        );

        if (initialLen > 0) {
          canvas.drawPath(
            metric.extractPath(0, initialLen),
            paint,
          );
        }
      }

      while (distance < metric.length) {
        final len = math.min(
          dashLength,
          metric.length - distance,
        );

        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + len,
          ),
          paint,
        );

        distance += pattern;
      }
    }
  }

  void _drawStaticDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLength,
    required double gapLength,
  }) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;

      while (distance < metric.length) {
        final len = math.min(
          dashLength,
          metric.length - distance,
        );

        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + len,
          ),
          paint,
        );

        distance += dashLength + gapLength;
      }
    }
  }
}