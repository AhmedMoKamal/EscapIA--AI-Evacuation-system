import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/core/errors/exceptions.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<String> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.authEndpoint,
        data: {'phoneNumber': phoneNumber, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractToken(response.data);
      }
      throw ServerException(
        'Login failed with status code: ${response.statusCode}',
      );
    } on DioException catch (e) {
      final apiMessage = _extractErrorMessage(e.response?.data);
      if (apiMessage != null) {
        throw ServerException(apiMessage);
      }
      if (e.response?.statusCode == 401) {
        throw ServerException('Invalid phone number or password');
      }
      throw ServerException(
        'Login failed: ${e.message ?? 'The server did not respond'}',
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error during login: $e');
    }
  }

  String _extractToken(dynamic data) {
    if (data is! Map) {
      throw ServerException('Unexpected login response format');
    }

    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw ServerException('Token missing in login response');
    }

    return token;
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final message = data['message'] ?? data['title'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final errors = data['errors'];
    if (errors is Map) {
      final messages = errors.values
          .expand((value) => value is List ? value : [value])
          .whereType<String>()
          .where((value) => value.trim().isNotEmpty)
          .toList();
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    return null;
  }
}
