import 'package:escapia/features/overview/data/datasources/building_state_remote_data_source.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';
import 'package:escapia/features/overview/domain/repositories/building_state_repository.dart';

class BuildingStateRepositoryImpl implements BuildingStateRepository {
  final BuildingStateRemoteDataSource remoteDataSource;

  BuildingStateRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ZoneEntity>> getInitialState() async {
    final models = await remoteDataSource.fetchInitialState();
    return models.map<ZoneEntity>((model) => model).toList();
  }

  @override
  Future<void> startListening() async {
    await remoteDataSource.connect();
  }

  @override
  Future<void> stopListening() async {
    await remoteDataSource.disconnect();
  }

  @override
  Stream<ZoneEntity> watchBuildingState() {
    return remoteDataSource.watchBuildingState();
  }
}