class IncidentEntity {
  final int id;
  final String incidentId;
  final String startAt;
  final String endAt;
  final String status;

  const IncidentEntity({
    required this.id,
    required this.incidentId,
    required this.startAt,
    required this.endAt,
    required this.status,
  });
}
