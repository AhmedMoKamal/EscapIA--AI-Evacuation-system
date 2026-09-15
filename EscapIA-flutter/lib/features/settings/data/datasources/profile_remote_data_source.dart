import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/core/errors/exceptions.dart';
import 'package:escapia/core/utils/error_meassage_heper.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get(ApiEndpoints.profileEndpoint);

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ProfileModel.fromJson(data);
      }
      throw ServerException('Failed to load profile data');
    } on DioException catch (e) {
      throw ServerException(
        ErrorMessageHelper.getUserFriendlyMessage(
          'Failed to load profile data: ${e.response?.statusCode} - ${e.message}',
        ),
      );
    } catch (e) {
      throw ServerException(
        ErrorMessageHelper.getUserFriendlyMessage(e),
      );
    }
  }
}