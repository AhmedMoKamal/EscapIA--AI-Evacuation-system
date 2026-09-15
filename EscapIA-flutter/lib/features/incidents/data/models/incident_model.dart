import '../../domain/entities/incident_entity.dart';

class IncidentModel extends IncidentEntity {
  const IncidentModel({
    required super.id,
    required super.incidentId,
    required super.startAt,
    required super.endAt,
    required super.status,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] ?? 0,
      incidentId: json['incidentId'] ?? '',
      startAt: json['startAt'],
      endAt: json['endAt'],
      status: json['status'],
    );
  }
}
