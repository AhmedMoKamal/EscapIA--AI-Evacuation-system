import 'package:escapia/features/overview/domain/entities/zone_entity.dart';

class ZoneModel extends ZoneEntity {
  const ZoneModel({
    required super.id,
    required super.zoneId,
    required super.smokeDetected,
    required super.crowdDensity,
    required super.peopleCount,
    required super.fireDetected,
    required super.riskLevel,
    required super.evacuationRequired,
    required super.instruction,
    required super.fullRoute,
    required super.isRerouted,
    required super.timestamp,
    required super.safeExitsCount,
    required super.totalExits,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      zoneId: json['zoneId']?.toString() ?? '',
      smokeDetected: json['smokeDetected'] as bool? ?? false,
      crowdDensity: json['crowdDensity']?.toString() ?? 'Normal',
      peopleCount: (json['peopleCount'] as num?)?.toInt() ?? 0,
      fireDetected: json['fireDetected'] as bool? ?? false,
      riskLevel: json['riskLevel']?.toString() ?? 'Low',
      evacuationRequired: json['evacuationRequired'] as bool? ?? false,
      instruction: json['instruction']?.toString() ?? '',
      fullRoute: (json['fullRoute'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isRerouted: json['isRerouted'] as bool? ?? false,
      timestamp: _parseDateTime(json['timestamp']),
      safeExitsCount: (json['safeExitsCount'] as num?)?.toInt() ?? 0,
      totalExits: (json['totalExits'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zoneId': zoneId,
      'smokeDetected': smokeDetected,
      'crowdDensity': crowdDensity,
      'peopleCount': peopleCount,
      'fireDetected': fireDetected,
      'riskLevel': riskLevel,
      'evacuationRequired': evacuationRequired,
      'instruction': instruction,
      'fullRoute': fullRoute,
      'isRerouted': isRerouted,
      'timestamp': timestamp.toIso8601String(),
      'safeExitsCount': safeExitsCount,
      'totalExits': totalExits,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}