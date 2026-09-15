import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/core/errors/exceptions.dart';
import 'package:escapia/core/utils/error_meassage_heper.dart';
import 'package:escapia/features/incidents/data/models/incident_report_model.dart';

class ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSource(this.dio);

  Future<IncidentReportModel> getReport(String incidentId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.incidentReportEndpoint(incidentId),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*',
          },
        ),
      );

      return IncidentReportModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException(
          ErrorMessageHelper.getUserFriendlyMessage('Not found: $incidentId'),
        );
      }
      throw ServerException(
        ErrorMessageHelper.getUserFriendlyMessage(
          'Server Error: ${e.response?.statusCode} - ${e.message}',
        ),
      );
    } catch (e) {
      throw ServerException(
        ErrorMessageHelper.getUserFriendlyMessage(e),
      );
    }
  }
}
