import 'package:escapia/features/overview/domain/entities/zone_entity.dart';

class ZoneSafetyHelper {
  ZoneSafetyHelper._();
  static bool isZoneDanger(ZoneEntity zone) {
    if (zone.fireDetected) return true;
    if (zone.smokeDetected) return true;
    if (zone.evacuationRequired) return true;
    if (zone.isRerouted) return true;
    final risk = zone.riskLevel.trim().toLowerCase();
    if (risk.isNotEmpty &&
        risk != 'low' &&
        risk != 'safe' &&
        risk != 'normal' &&
        risk != 'none') {
      return true;
    }
    return false;
  }

  static String normalizeNode(String value) {
    String clean = value
        .trim()
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (clean.startsWith('exist')) clean = clean.replaceFirst('exist', 'exit');
    if (clean == 'exita' || clean == 'a' || clean == 'exit1') return 'exita';
    if (clean == 'exitb' || clean == 'b' || clean == 'exit2') return 'exitb';
    if (RegExp(r'^\d+$').hasMatch(clean)) return 'zone$clean';
    return clean;
  }
  static bool matchesZone(ZoneEntity z, String zoneKey) {
    final normZ = normalizeNode(z.zoneId);
    final normKey = normalizeNode(zoneKey);
    if (normZ.isNotEmpty && normZ == normKey) return true;
    final keyDigits = RegExp(r'\d+').firstMatch(zoneKey)?.group(0);
    final keyNum = int.tryParse(keyDigits ?? '');
    if (keyNum != null) {
      if (z.id == keyNum) return true;
      final zDigits = RegExp(r'\d+').firstMatch(z.zoneId)?.group(0);
      if (int.tryParse(zDigits ?? '') == keyNum) return true;
    }
    return false;
  }

  static bool isDanger(String zoneId, List<ZoneEntity> zones) {
    for (final z in zones) {
      if (matchesZone(z, zoneId)) {
        if (zones.length < 8) return true;
        if (isZoneDanger(z)) return true;
      }
    }
    return false;
  }

  static List<List<String>> findAllSafeRoutes(List<ZoneEntity> zones) {
    final List<List<String>> allRoutes = [];
    for (final z in zones) {
      if ((isZoneDanger(z) || z.isRerouted || zones.length < 8) &&
          z.fullRoute.length >= 2) {
        allRoutes.add(z.fullRoute);
      }
    }
    if (allRoutes.isEmpty) {
      for (final z in zones) {
        if (z.fullRoute.length >= 2) allRoutes.add(z.fullRoute);
      }
    }
    return allRoutes;
  }
}
