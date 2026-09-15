import 'package:dio/dio.dart';
import 'package:escapia/core/utils/auth_notifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioInterceptor extends Interceptor {
  static const String tokenKey = 'access_token';

  final FlutterSecureStorage _storage;
  final AuthNotifier authNotifier;

  DioInterceptor({
    required this.authNotifier,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthEndpoint = options.uri.path == '/api/Auth';

    if (!isAuthEndpoint) {
      final String? token = await _storage.read(key: tokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final isLoginEndpoint = err.requestOptions.uri.path == '/api/Auth';

      if (!isLoginEndpoint) {
        await _storage.delete(key: tokenKey);
        authNotifier.logout();
      }
    }
    handler.next(err);
  }
}