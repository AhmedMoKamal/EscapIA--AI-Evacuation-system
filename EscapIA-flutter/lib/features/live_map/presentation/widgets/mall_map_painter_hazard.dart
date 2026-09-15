part of 'custom_map_painter.dart';

extension MallMapPainterHazard on MallMapPainter {
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

  void _drawDangerRadarWaves(Canvas canvas) {
    for (int i = 1; i <= 8; i++) {
      final key = 'Zone_$i';
      final hazard = _getZoneHazard(key);

      if (hazard == ZoneHazardType.none) continue;

      final rect = MallMapConstants.zoneRects[key];

      if (rect == null) continue;

      final center = rect.center;

      final Color waveColor = hazard == ZoneHazardType.smoke
          ? AppColors.warningAmber
          : AppColors.vividRed;

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
        final double progress =
            (animProgress + (w / waveCount)) % 1.0;

        final double radius =
            minRadius + progress * (maxRadius - minRadius);

        final double opacity = (1.0 - progress) * 0.65;

        if (opacity <= 0.02) continue;

        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = waveColor.withOpacity(opacity * 0.55)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.2
            ..maskFilter =
                const MaskFilter.blur(BlurStyle.normal, 4),
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

      final pulse =
          (math.sin(animProgress * 2 * math.pi) + 1) / 2;

      canvas.drawCircle(
        center,
        minRadius + (pulse * 8.0),
        Paint()
          ..color = waveColor.withOpacity(0.22 + 0.15 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..maskFilter =
              const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }
}