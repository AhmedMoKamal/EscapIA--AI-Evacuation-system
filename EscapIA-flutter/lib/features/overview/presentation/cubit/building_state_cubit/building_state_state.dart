import 'package:escapia/core/errors/error_handler.dart';
import 'package:escapia/features/overview/domain/entities/zone_entity.dart';

abstract class BuildingStateState {}

class BuildingStateInitial extends BuildingStateState {}

class BuildingStateLoading extends BuildingStateState {}

class BuildingStateLoaded extends BuildingStateState {
  final List<ZoneEntity> zones;
  BuildingStateLoaded(this.zones);
}

class BuildingStateError extends BuildingStateState {
  final AppError error; 
  BuildingStateError(this.error);
}
