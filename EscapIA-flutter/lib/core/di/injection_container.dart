import 'package:dio/dio.dart';
import 'package:escapia/core/constants/api_endpoints.dart';
import 'package:escapia/core/di/features/auth/auth_injection.dart';
import 'package:escapia/core/di/features/incidents/incidents_injection.dart';
import 'package:escapia/core/di/features/overview/overview_injection.dart';
import 'package:escapia/core/di/features/profile/profile_injection.dart';
import 'package:escapia/core/utils/auth_notifier.dart';
import 'package:escapia/core/network/dio_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      DioInterceptor(
        authNotifier: sl<AuthNotifier>(),
        storage: sl<FlutterSecureStorage>(),
      ),
    );

    return dio;
  });

  sl.registerLazySingleton<AuthNotifier>(
    () => AuthNotifier(storage: sl<FlutterSecureStorage>()),
  );
  initAuthInjection(sl);
  initOverviewInjection(sl);
  initIncidentsInjection(sl);
  initProfileInjection(sl);

  await sl<AuthNotifier>().restoreSession();
}