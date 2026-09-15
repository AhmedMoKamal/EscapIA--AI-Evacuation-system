import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/active_incidents_card.dart';
import 'package:escapia/features/overview/presentation/widgets/map_card.dart';
import 'package:flutter/material.dart';

class OverviewMobileLayout extends StatelessWidget {
  final List<ZoneEntity> data;

  const OverviewMobileLayout({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ZoneEntity? fireZone;
    for (final zone in data) {
      if (zone.fireDetected) {
        fireZone = zone;
        break;
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.space(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: context.space(16)),
          if (fireZone != null) ...[
            SizedBox(
              height: context.space(340),
              child: MapCard(zones: data),
            ),
          ] else ...[
            ActiveIncidentsPanel(zones: data),
            SizedBox(height: context.space(16)),
            SizedBox(
              height: context.space(380),
              child: MapCard(zones: data),
            ),
          ],
          SizedBox(height: context.space(16)),
        ],
      ),
    );
  }
}