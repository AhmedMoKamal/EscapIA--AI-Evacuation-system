import 'dart:math' as math;
import 'package:escapia/core/constants/mall_map_constants.dart';
import 'package:escapia/features/live_map/presentation/widgets/custom_map_painter.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:flutter/material.dart';

class LiveMapCanvas extends StatefulWidget {
  final List<ZoneEntity> zones;
  final List<List<String>> safeRoutes;
  final bool showDistances;
  final double zoomScale;
  final ValueChanged<double> onFitScaleCalculated;

  const LiveMapCanvas({
    super.key,
    required this.zones,
    required this.safeRoutes,
    required this.showDistances,
    required this.zoomScale,
    required this.onFitScaleCalculated,
  });

  @override
  State<LiveMapCanvas> createState() => _LiveMapCanvasState();
}

class _LiveMapCanvasState extends State<LiveMapCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final ScrollController _vController = ScrollController();
  final ScrollController _hController = ScrollController();

  Size? _lastConstraintSize;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _vController.dispose();
    _hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 768;
        final double outerPadding = isMobile ? 12.0 : 28.0;

        final currentSize = Size(constraints.maxWidth, constraints.maxHeight);
        final bool sizeChanged = _lastConstraintSize == null ||
            (_lastConstraintSize!.width - currentSize.width).abs() > 40 ||
            (_lastConstraintSize!.height - currentSize.height).abs() > 40;

        if (sizeChanged && constraints.maxWidth > 0 && constraints.maxHeight > 0) {
          _lastConstraintSize = currentSize;
          final double paddingTotal = outerPadding * 2;
          final double fitScale = math.min(
            (constraints.maxWidth - paddingTotal) / MallMapConstants.baseWidth,
            (constraints.maxHeight - paddingTotal) / MallMapConstants.baseHeight,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onFitScaleCalculated(fitScale.clamp(0.2, 1.0));
            }
          });
        }

        final double currentW = MallMapConstants.baseWidth * widget.zoomScale;
        final double currentH = MallMapConstants.baseHeight * widget.zoomScale;

        return Scrollbar(
          controller: _vController,
          thumbVisibility: widget.zoomScale > 1.0,
          child: Scrollbar(
            controller: _hController,
            thumbVisibility: widget.zoomScale > 1.0,
            notificationPredicate: (n) => n.depth == 1,
            child: SingleChildScrollView(
              controller: _vController,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: _hController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(outerPadding),
                      child: SizedBox(
                        width: currentW,
                        height: currentH,
                        child: AnimatedBuilder(
                          animation: _animController,
                          builder: (context, _) {
                            return CustomPaint(
                              size: Size(currentW, currentH),
                              painter: MallMapPainter(
                                zones: widget.zones,
                                safeRoutes: widget.safeRoutes,
                                animProgress: _animController.value,
                                showDistances: widget.showDistances,
                                zoomScale: widget.zoomScale,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}