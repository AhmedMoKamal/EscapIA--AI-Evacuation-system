import 'package:dio/dio.dart';
import 'package:escapia/features/security_auth/data/datasources/security_auth_data_source.dart';
import 'package:escapia/features/security_auth/data/repositories/security_auth_repo_impl.dart';
import 'package:escapia/features/security_auth/domain/repositories/security_auth_repo.dart';
import 'package:escapia/features/security_auth/presentation/cubit/security_auth_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

void initAuthInjection(GetIt sl) {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      dio: sl<Dio>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl<AuthRepository>()),
  );
}