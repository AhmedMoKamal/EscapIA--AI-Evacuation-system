part of 'custom_map_painter.dart';

extension MallMapPainterUi on MallMapPainter {
  void _drawZoneCards(Canvas canvas) {
    for (int i = 1; i <= 8; i++) {
      final key = 'Zone_$i';
      final rect = MallMapConstants.zoneRects[key];
      if (rect == null) continue;
      final hazard = _getZoneHazard(key);
      final rrect =
          RRect.fromRectAndRadius(
        rect,
        const Radius.circular(16),
      );
      late final Color cardColor;
      late final Color borderColor;

      if (hazard == ZoneHazardType.smoke) {
        borderColor = AppColors.warningAmber;
        cardColor =
            AppColors.warningAmber.withOpacity(0.14);
      } else if (hazard == ZoneHazardType.fire) {
        borderColor = AppColors.vividRed;
        cardColor =
            AppColors.criticalCrimson.withOpacity(0.35);
      } else {
        borderColor = AppColors.successEmerald80;
        cardColor = AppColors.cardBackground;
      }
      final bool isDanger =
          hazard != ZoneHazardType.none;

      canvas.drawRRect(
        rrect,
        Paint()..color = cardColor,
      );
      canvas.drawRRect(
        rrect,
        Paint()
          ..color =
              borderColor.withOpacity(isDanger ? 0.45 : 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isDanger ? 4.5 : 3.5
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            isDanger ? 8 : 4,
          ),
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
  void _drawZoneLabelsAndIcons(Canvas canvas) {
    for (int i = 1; i <= 8; i++) {
      final key = 'Zone_$i';
      final rect = MallMapConstants.zoneRects[key];

      if (rect == null) continue;

      final hazard = _getZoneHazard(key);

      if (hazard != ZoneHazardType.none) {
        final bool isSmoke =
            hazard == ZoneHazardType.smoke;

        final Color hazardColor =
            isSmoke
                ? AppColors.warningAmber
                : AppColors.intenseRed;

        final Color glowColor =
            isSmoke
                ? const Color(0xFFFFB74D)
                : AppColors.vividRed;

        final IconData hazardIcon =
            isSmoke
                ? Icons.air_rounded
                : Icons.local_fire_department_rounded;

        _drawHazardIcon(
          canvas,
          Offset(
            rect.center.dx,
            rect.center.dy - 12,
          ),
          icon: hazardIcon,
          color: hazardColor,
          glowColor: glowColor,
        );

        _drawCenteredText(
          canvas,
          Offset(
            rect.center.dx,
            rect.center.dy + 18,
          ),
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
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 8),
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

  void _drawExitBtn(
    Canvas canvas,
    Rect rect,
    String label,
    String exitKey,
  ) {
    final isSafe = _isExitSafe(exitKey);

    final accentColor =
        isSafe
            ? AppColors.successEmerald80
            : AppColors.vividRed;

    final bgColor =
        isSafe
            ? AppColors.cardBackground
            : AppColors.criticalCrimson.withOpacity(0.35);

    final rrect =
        RRect.fromRectAndRadius(
      rect,
      const Radius.circular(10),
    );

    canvas.drawRRect(
      rrect,
      Paint()..color = bgColor,
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = accentColor.withOpacity(0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 4),
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
      style: AppTextStyles.font16W700.copyWith(
        color: accentColor,
      ),
    );
  }
  void _drawCenteredText(
    Canvas canvas,
    Offset center,
    String text, {
    required TextStyle style,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(
        center.dx - tp.width / 2,
        center.dy - tp.height / 2,
      ),
    );
  }
  void _drawDistanceBadge(
    Canvas canvas,
    Offset center,
    String text,
  ) {
    final rect = Rect.fromCenter(
      center: center,
      width: 44,
      height: 22,
    );
    final rrect =
        RRect.fromRectAndRadius(
      rect,
      const Radius.circular(6),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color =
            AppColors.darkNavyBackground.withOpacity(0.95),
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
  void _drawGlowingDistanceBadge(
    Canvas canvas,
    Offset center,
    String text,
  ) {
    final rect = Rect.fromCenter(
      center: center,
      width: 46,
      height: 24,
    );
    final rrect =
        RRect.fromRectAndRadius(
      rect,
      const Radius.circular(6),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color =
            AppColors.brightCyan.withOpacity(0.4)
        ..maskFilter =
            const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = AppColors.deepCyanNavy,
    );
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
}