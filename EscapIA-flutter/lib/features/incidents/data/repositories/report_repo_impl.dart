import 'package:escapia/core/errors/exceptions.dart';
import 'package:escapia/core/utils/error_meassage_heper.dart';
import 'package:escapia/features/incidents/data/datasources/report_data_source.dart';
import '../../domain/entities/incident_report_entity.dart';
import '../../domain/repositories/report_repo.dart';

class ReportRepoImpl implements ReportRepo {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepoImpl(this.remoteDataSource);

  @override
  Future<IncidentReportEntity> getReport(String incidentId) async {
    try {
      return await remoteDataSource.getReport(incidentId);
    } on ServerException catch (e) {
      throw ServerException(ErrorMessageHelper.getUserFriendlyMessage(e));
    } catch (e) {
      throw ServerException(ErrorMessageHelper.getUserFriendlyMessage(e));
    }
  }
}