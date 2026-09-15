import 'package:escapia/features/incidents/domain/entities/incident_entity.dart';

abstract class IncidentsRepository {
  Future<List<IncidentEntity>> getBasicIncidents();
}
