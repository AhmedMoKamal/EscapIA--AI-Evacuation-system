import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  double get screenWidth => width;
  double get screenHeight => height;

  bool get isSmallMobile => width < 360;
  bool get isMobile => width < 768;
  bool get isWeb => width >= 768;

  double space(double baseValue) {
    final double scale = (width / 1440).clamp(0.85, 1.25);
    return baseValue * scale;
  }
  double get dialogWidth {
    if (isMobile) return double.infinity;
    return space(600).clamp(space(400), space(750));
  }
  double get maxDialogHeight {
    return space(650).clamp(space(350), space(750));
  }
}