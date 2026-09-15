import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:escapia/core/errors/error_handler.dart';
import 'package:escapia/features/incidents/domain/repositories/incidents_repo.dart';
import 'incidents_state.dart';

class IncidentsCubit extends Cubit<IncidentsState> {
  final IncidentsRepository repository;

  IncidentsCubit({required this.repository}) : super(const IncidentsInitial());

  Future<void> getBasicIncidents() async {
    emit(const IncidentsLoading());

    try {
      final incidents = await repository.getBasicIncidents();
      emit(IncidentsLoaded(incidents));
    } catch (e) {
      emit(IncidentsError(ErrorHandler.handle(e)));
    }
  }
}