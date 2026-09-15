import 'package:escapia/core/errors/error_handler.dart';
import 'package:escapia/features/incidents/domain/entities/incident_entity.dart';

abstract class IncidentsState {
  const IncidentsState();
}

class IncidentsInitial extends IncidentsState {
  const IncidentsInitial();
}

class IncidentsLoading extends IncidentsState {
  const IncidentsLoading();
}

class IncidentsLoaded extends IncidentsState {
  final List<IncidentEntity> incidents;

  const IncidentsLoaded(this.incidents);
}

class IncidentsError extends IncidentsState {
final AppError error; 
  const IncidentsError(this.error);
}