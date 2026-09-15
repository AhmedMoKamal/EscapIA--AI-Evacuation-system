import 'dart:math' as math;
import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/constants/app_text_styles.dart';
import 'package:escapia/core/constants/mall_map_constants.dart';
import 'package:escapia/core/utils/zone_safety_helper.dart';
import 'package:escapia/features/live_map/data/models/edge_connection_model.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:flutter/material.dart';
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

  ZoneHazardType _getZoneHazard(String zoneId) {
    final normTarget =
        zoneId.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    for (final z in zones) {
      final normBackend =
          z.zoneId.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

      final bool isMatch = normBackend == normTarget ||
          normBackend == 'zone$normTarget' ||
          'zone$normBackend' == normTarget;

      if (isMatch) {
        final bool isFire = z.fireDetected == true;
        final bool isSmoke = z.smokeDetected == true;
        final risk = z.riskLevel.trim().toLowerCase();

        if (isFire) {
          return ZoneHazardType.fire;
        }

        if (isSmoke || risk == 'smoke') {
          return ZoneHazardType.smoke;
        }
        final bool isHighRisk =
            risk == 'high' || risk == 'critical' || risk == 'danger';
        if (isHighRisk || z.evacuationRequired == true) {
          return ZoneHazardType.fire;
        }

        if (risk == 'medium' || risk == 'warning') {
          return ZoneHazardType.smoke;
        }
      }
    }
    return ZoneHazardType.none;
  }

  bool _isExitSafe(String exitKey) =>
      _getZoneHazard(exitKey) == ZoneHazardType.none;

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

  void _drawEdges(Canvas canvas) {
    for (final edge in MallMapConstants.edges) {
      final rawPts = MallMapConstants.pathMap[edge.id];
      if (rawPts == null || rawPts.length < 2) continue;

      final int routeDirection = _getEdgeRouteDirection(edge);
      final bool isSafe = routeDirection != 0;
      final List<Offset> pts =
          (routeDirection == -1) ? rawPts.reversed.toList() : rawPts;

      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }

      if (isSafe) {
        final pulseVal = (math.sin(animProgress * 2 * math.pi) + 1) / 2;
        final glowColor =
            AppColors.brightCyan.withOpacity(0.35 + (0.25 * pulseVal));

        canvas.drawPath(
          path,
          Paint()
            ..color = glowColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
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
              MallMapConstants.badgeOffsets[edge.id] ?? pts[pts.length ~/ 2];
          _drawGlowingDistanceBadge(canvas, bOffset, '${edge.weight}m');
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
              MallMapConstants.badgeOffsets[edge.id] ?? pts[pts.length ~/ 2];
          _drawDistanceBadge(canvas, bOffset, '${edge.weight}m');
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
          canvas.drawPath(metric.extractPath(0, initialLen), paint);
        }
      }
      while (distance < metric.length) {
        final len = math.min(dashLength, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
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
        final len = math.min(dashLength, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  void _drawZoneCards(Canvas canvas) {
    for (int i = 1; i <= 8; i++) {
      final key = 'Zone_$i';
      final rect = MallMapConstants.zoneRects[key];
      if (rect == null) continue;

      final hazard = _getZoneHazard(key);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

      late final Color cardColor;
      late final Color borderColor;

      if (hazard == ZoneHazardType.smoke) {
        borderColor = AppColors.warningAmber;
        cardColor = AppColors.warningAmber.withOpacity(0.14);
      } else if (hazard == ZoneHazardType.fire) {
        borderColor = AppColors.vividRed;
        cardColor = AppColors.criticalCrimson.withOpacity(0.35);
      } else {
        borderColor = AppColors.successEmerald80;
        cardColor = AppColors.cardBackground;
      }

      final bool isDanger = hazard != ZoneHazardType.none;

      canvas.drawRRect(rrect, Paint()..color = cardColor);
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = borderColor.withOpacity(isDanger ? 0.45 : 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isDanger ? 4.5 : 3.5
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDanger ? 8 : 4),
      );
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = isDanger ? 2.6 : 2.2,
      );
    }

    if (MallMapConstants.zoneRects['Exit_A'] != null) {
      _drawExitBtn(
        canvas,
        MallMapConstants.zoneRects['Exit_A']!,
        'EXIT A',
        'Exit_A',
      );
    }
    if (MallMapConstants.zoneRects['Exit_B'] != null) {
      _drawExitBtn(
        canvas,
        MallMapConstants.zoneRects['Exit_B']!,
        'EXIT B',
        'Exit_B',
      );
    }
  }

  void _drawDangerRadarWaves(Canvas canvas) {
    for (int i = 1; i <= 8; i++) {
      final key = 'Zone_$i';
      final hazard = _getZoneHazard(key);
      if (hazard == ZoneHazardType.none) continue;

      final rect = MallMapConstants.zoneRects[key];
      if (rect == null) continue;

      final center = rect.center;

      final Color waveColor =
          hazard == ZoneHazardType.smoke ? AppColors.warningAmber : AppColors.vividRed;
      final Color pulseColor = hazard == ZoneHazardType.smoke
          ? const Color(0xFFFFB74D)
          : AppColors.vividRed;

      const staticRadii = [80.0, 140.0, 200.0];
      for (final r in staticRadii) {
        canvas.drawCircle(
          center,
          r,
          Paint()
            ..color = waveColor.withOpacity(0.14)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
      }

      const int waveCount = 4;
      const double minRadius = 45.0;
      const double maxRadius = 260.0;

      for (int w = 0; w < waveCount; w++) {
        final double progress = (animProgress + (w / waveCount)) % 1.0;
        final double radius = minRadius + progress * (maxRadius - minRadius);
        final double opacity = (1.0 - progress) * 0.65;

        if (opacity <= 0.02) continue;

        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = waveColor.withOpacity(opacity * 0.55)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.2
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );

        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = pulseColor.withOpacity(opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6,
        );
      }

      final pulse = (math.sin(animProgress * 2 * math.pi) + 1) / 2;
      canvas.drawCircle(
        center,
        minRadius + (pulse * 8.0),
        Paint()
          ..color = waveColor.withOpacity(0.22 + 0.15 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  void _drawZoneLabelsAndIcons(Canvas canvas) {
    for (int i = 1; i <= 8; i++) {
      final key = 'Zone_$i';
      final rect = MallMapConstants.zoneRects[key];
      if (rect == null) continue;

      final hazard = _getZoneHazard(key);

      if (hazard != ZoneHazardType.none) {
        final bool isSmoke = hazard == ZoneHazardType.smoke;

        final Color hazardColor =
            isSmoke ? AppColors.warningAmber : AppColors.intenseRed;
        final Color glowColor =
            isSmoke ? const Color(0xFFFFB74D) : AppColors.vividRed;
        final IconData hazardIcon =
            isSmoke ? Icons.air_rounded : Icons.local_fire_department_rounded;

        _drawHazardIcon(
          canvas,
          Offset(rect.center.dx, rect.center.dy - 12),
          icon: hazardIcon,
          color: hazardColor,
          glowColor: glowColor,
        );

        _drawCenteredText(
          canvas,
          Offset(rect.center.dx, rect.center.dy + 18),
          'ZONE $i',
          style: AppTextStyles.font15W700Spacing.copyWith(
            color: hazardColor,
          ),
        );
      } else {
        _drawCenteredText(
          canvas,
          rect.center,
          'ZONE $i',
          style: AppTextStyles.font22W700,
        );
      }
    }
  }

  void _drawHazardIcon(
    Canvas canvas,
    Offset center, {
    required IconData icon,
    required Color color,
    required Color glowColor,
  }) {
    canvas.drawCircle(
      center,
      16,
      Paint()
        ..color = color.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 34,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
          shadows: [
            Shadow(
              color: glowColor,
              blurRadius: 10,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );
  }

  void _drawExitBtn(Canvas canvas, Rect rect, String label, String exitKey) {
    final isSafe = _isExitSafe(exitKey);
    final accentColor = isSafe ? AppColors.successEmerald80 : AppColors.vividRed;
    final bgColor =
        isSafe ? AppColors.cardBackground : AppColors.criticalCrimson.withOpacity(0.35);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));

    canvas.drawRRect(rrect, Paint()..color = bgColor);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = accentColor.withOpacity(0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    _drawCenteredText(
      canvas,
      rect.center,
      label,
      style: AppTextStyles.font16W700.copyWith(color: accentColor),
    );
  }

  void _drawCenteredText(
    Canvas canvas,
    Offset center,
    String text, {
    required TextStyle style,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  void _drawDistanceBadge(Canvas canvas, Offset center, String text) {
    final rect = Rect.fromCenter(center: center, width: 44, height: 22);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(
      rrect,
      Paint()..color = AppColors.darkNavyBackground.withOpacity(0.95),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = AppColors.steelBlueGray
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    _drawCenteredText(
      canvas,
      center,
      text,
      style: AppTextStyles.font11W700,
    );
  }

  void _drawGlowingDistanceBadge(Canvas canvas, Offset center, String text) {
    final rect = Rect.fromCenter(center: center, width: 46, height: 24);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = AppColors.brightCyan.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawRRect(rrect, Paint()..color = AppColors.deepCyanNavy);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = AppColors.brightCyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    _drawCenteredText(
      canvas,
      center,
      text,
      style: AppTextStyles.font11W700Cyan,
    );
  }

  @override
  bool shouldRepaint(covariant MallMapPainter oldDelegate) => true;
}