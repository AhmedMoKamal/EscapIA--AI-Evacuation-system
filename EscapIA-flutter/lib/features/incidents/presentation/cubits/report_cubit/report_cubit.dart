import 'package:escapia/core/errors/error_handler.dart';
import 'package:escapia/features/incidents/domain/repositories/report_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepo repository;

  ReportCubit({required this.repository}) : super(ReportInitial());

  Future<void> getIncidentReport(String incidentId) async {
    emit(ReportLoading());

    try {
      final reportEntity = await repository.getReport(incidentId);
      emit(ReportSuccess(reportEntity));
    } catch (e) {
      emit(ReportError( ErrorHandler.handle(e)));
    }
  }
}