import 'package:escapia/features/incidents/data/datasources/incidents_remote_data_sourec.dart';
import 'package:escapia/features/incidents/domain/entities/incident_entity.dart';
import 'package:escapia/features/incidents/domain/repositories/incidents_repo.dart';

class IncidentsRepositoryImpl implements IncidentsRepository {
  final IncidentsRemoteDataSource remoteDataSource;

  IncidentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<IncidentEntity>> getBasicIncidents() async {
    try {
      final models = await remoteDataSource.getBasicIncidents();
      return models;
    } catch (e) {
      rethrow;
    }
  }
}
