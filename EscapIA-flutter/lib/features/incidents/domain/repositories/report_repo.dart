import '../entities/incident_report_entity.dart';

abstract class ReportRepo {
  Future<IncidentReportEntity> getReport(String incidentId);
}