import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/core/errors/exceptions.dart';
import 'package:escapia/core/utils/error_meassage_heper.dart';
import 'package:escapia/features/incidents/data/models/incident_model.dart';

class IncidentsRemoteDataSource {
  final Dio dio;

  IncidentsRemoteDataSource({required this.dio});

  Future<List<IncidentModel>> getBasicIncidents() async {
    try {
      final response = await dio.get(
        ApiEndpoints.incidentsEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final dynamic data = response.data;
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => IncidentModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (data is Map<String, dynamic> && data['data'] is List) {
        final List<dynamic> list = data['data'];
        return list
            .whereType<Map>()
            .map((e) => IncidentModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      throw ServerException('Unexpected response format');
    } on DioException catch (e) {
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