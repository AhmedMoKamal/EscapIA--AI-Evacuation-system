import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/core/utils/auth_notifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_interceptor.dart';

class ApiService {
  late Dio dio;

  ApiService(AuthNotifier authNotifier) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      DioInterceptor(
        authNotifier: authNotifier,
        storage: const FlutterSecureStorage(),
      ),
    );
  }
}