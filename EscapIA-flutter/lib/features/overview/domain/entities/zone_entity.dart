class ZoneEntity {
  final int id;
  final String zoneId;
  final bool smokeDetected;
  final String crowdDensity;
  final int peopleCount;
  final bool fireDetected;
  final String riskLevel;
  final bool evacuationRequired;
  final String instruction;
  final List<String> fullRoute;
  final bool isRerouted;
  final DateTime timestamp;
  final int safeExitsCount;
  final int totalExits;

  const ZoneEntity({
    required this.id,
    required this.zoneId,
    required this.smokeDetected,
    required this.crowdDensity,
    required this.peopleCount,
    required this.fireDetected,
    required this.riskLevel,
    required this.evacuationRequired,
    required this.instruction,
    required this.fullRoute,
    required this.isRerouted,
    required this.timestamp,
    required this.safeExitsCount,
    required this.totalExits,
  });
}