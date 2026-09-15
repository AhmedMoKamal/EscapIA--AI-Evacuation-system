import '../../domain/entities/incident_report_entity.dart';

class IncidentReportModel extends IncidentReportEntity {
  const IncidentReportModel({
    required super.content,
  });

  factory IncidentReportModel.fromJson(dynamic data) {
    return IncidentReportModel(
      content: data.toString(),
    );
  }
}