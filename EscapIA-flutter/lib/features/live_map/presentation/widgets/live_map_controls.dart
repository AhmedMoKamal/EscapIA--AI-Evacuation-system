import 'package:escapia/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LiveMapControls extends StatelessWidget {
  final bool showDistances;
  final VoidCallback onToggleDistances;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomReset;

  const LiveMapControls({
    super.key,
    required this.showDistances,
    required this.onToggleDistances,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onZoomReset,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final bool isMobile = screenSize.width < 768;
    final bool isLandscapeShort = screenSize.height < 500;

    final double buttonSize = isMobile ? 30.0 : 38.0;
    final double iconSize = isMobile ? 16.0 : 20.0;
    final double dividerLength = isMobile ? 18.0 : 24.0;
    final double containerPadding = isMobile ? 2.0 : 4.0;
    final double borderRadius = isMobile ? 8.0 : 10.0;

    final items = [
      _btn(
        showDistances ? Icons.straighten : Icons.straighten_outlined,
        showDistances ? AppColors.brightCyan : AppColors.slateGrayText,
        'Toggle distances',
        onToggleDistances,
        buttonSize,
        iconSize,
        isMobile,
      ),
      _divider(isLandscapeShort, dividerLength, isMobile),
      _btn(
        Icons.add,
        AppColors.brightCyan,
        'Zoom in',
        onZoomIn,
        buttonSize,
        iconSize,
        isMobile,
      ),
      _divider(isLandscapeShort, dividerLength, isMobile),
      _btn(
        Icons.remove,
        AppColors.brightCyan,
        'Zoom out',
        onZoomOut,
        buttonSize,
        iconSize,
        isMobile,
      ),
      _divider(isLandscapeShort, dividerLength, isMobile),
      _btn(
        Icons.refresh,
        AppColors.textWhite70,
        'Reset view',
        onZoomReset,
        buttonSize,
        iconSize,
        isMobile,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkNavyPanelBackground.withOpacity(0.92),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.steelBlueBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackOverlay40,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(containerPadding),
      child: isLandscapeShort
          ? Row(mainAxisSize: MainAxisSize.min, children: items)
          : Column(mainAxisSize: MainAxisSize.min, children: items),
    );
  }

  Widget _divider(bool isHorizontal, double length, bool isMobile) {
    final double margin = isMobile ? 1.0 : 2.0;
    return isHorizontal
        ? Container(
            width: 1,
            height: length,
            margin: EdgeInsets.symmetric(horizontal: margin),
            color: AppColors.borderWhite8,
          )
        : Container(
            width: length,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: margin),
            color: AppColors.borderWhite8,
          );
  }

  Widget _btn(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
    double buttonSize,
    double iconSize,
    bool isMobile,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isMobile ? 5 : 6),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }
}