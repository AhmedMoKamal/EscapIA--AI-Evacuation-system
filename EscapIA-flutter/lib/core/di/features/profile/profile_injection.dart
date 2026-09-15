import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:escapia/features/settings/data/datasources/profile_remote_data_source.dart';
import 'package:escapia/features/settings/data/repositories/profile_repo_impl.dart';
import 'package:escapia/features/settings/domain/repositories/profile_repo.dart';
import 'package:escapia/features/settings/presentation/cubit/profle_cubit/profile_cubit.dart';

void initProfileInjection(GetIt sl) {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<Dio>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(repository: sl<ProfileRepository>()),
  );
}
