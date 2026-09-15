import 'package:escapia/core/constants/app_colors.dart';
import 'package:escapia/core/utils/context_extension.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/incident_banner_header.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/no_active_incident.dart';
import 'package:escapia/features/overview/presentation/widgets/active_incidents_widgets/zone_details_card.dart';
import 'package:flutter/material.dart';

enum IncidentState { none, smoke, fire, resolved }

class ActiveIncidentsPanel extends StatefulWidget {
  final List<ZoneEntity> zones;
  final VoidCallback? onViewReport;

  const ActiveIncidentsPanel({
    super.key,
    required this.zones,
    this.onViewReport,
  });

  @override
  State<ActiveIncidentsPanel> createState() => _ActiveIncidentsPanelState();
}

class _ActiveIncidentsPanelState extends State<ActiveIncidentsPanel> {
  final Set<String> _collapsedZoneIds = {};

  @override
  Widget build(BuildContext context) {
    final activeZones = _getActiveZones();

    if (activeZones.isEmpty) {
      return const NoActiveIncidentsCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: activeZones.map((activeZone) {
        final incidentState = _determineIncidentState(activeZone);
        final (statusColor, bannerTitle, bannerIcon, cardBg) = _getBannerData(
          incidentState,
        );

        final bool isExpanded = !_collapsedZoneIds.contains(
          activeZone.zoneId,
        );

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: context.space(10)),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: statusColor.withOpacity(0.85),
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.space(12),
            vertical: context.space(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IncidentBannerHeader(
                icon: bannerIcon,
                title: bannerTitle,
                color: statusColor,
              ),
              SizedBox(height: context.space(8)),
              ZoneDetailsCard(
                activeZone: activeZone,
                incidentState: incidentState,
                statusColor: statusColor,
                isExpanded: isExpanded,
                onToggleExpand: () {
                  setState(() {
                    if (_collapsedZoneIds.contains(activeZone.zoneId)) {
                      _collapsedZoneIds.remove(activeZone.zoneId);
                    } else {
                      _collapsedZoneIds.add(activeZone.zoneId);
                    }
                  });
                },
                onViewReport: widget.onViewReport,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<ZoneEntity> _getActiveZones() {
    return widget.zones.where((z) {
      return z.fireDetected ||
          z.smokeDetected ||
          z.evacuationRequired;
    }).toList();
  }

  IncidentState _determineIncidentState(ZoneEntity? zone) {
    if (zone == null) return IncidentState.none;
    if (zone.fireDetected) return IncidentState.fire;
    if (zone.smokeDetected) return IncidentState.smoke;
    if (zone.evacuationRequired) return IncidentState.fire;
    return IncidentState.none;
  }

  (Color, String, IconData, Color) _getBannerData(IncidentState state) {
    return switch (state) {
      IncidentState.smoke => (
        AppColors.warningAmber,
        'SMOKE DETECTED',
        Icons.warning_amber_rounded,
        AppColors.incidentSmokeBackground,
      ),
      IncidentState.fire => (
        AppColors.criticalCrimson,
        'FIRE DETECTED',
        Icons.warning_amber_rounded,
        AppColors.incidentFireBackground,
      ),
      _ => (
        AppColors.cardBorder,
        '',
        Icons.info_outline,
        AppColors.cardBackground,
      ),
    };
  }
}
