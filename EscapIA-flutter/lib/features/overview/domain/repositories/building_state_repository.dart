import 'package:escapia/features/overview/domain/entities/zone_entity.dart';

abstract class BuildingStateRepository {
  Future<List<ZoneEntity>> getInitialState();
  Stream<ZoneEntity> watchBuildingState();
  Future<void> startListening();
  Future<void> stopListening();
}