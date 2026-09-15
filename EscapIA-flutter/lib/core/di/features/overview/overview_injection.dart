import 'package:escapia/features/overview/data/datasources/building_state_remote_data_source.dart';
import 'package:escapia/features/overview/data/repositories/building_state_repo_impl.dart';
import 'package:escapia/features/overview/presentation/cubit/building_state_cubit/building_state_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
void initOverviewInjection(GetIt sl) {
  sl.registerLazySingleton<BuildingStateRemoteDataSource>(
    () => BuildingStateRemoteDataSource(
      dio: sl<Dio>(),
    ),
  );

  sl.registerLazySingleton<BuildingStateRepositoryImpl>(
    () => BuildingStateRepositoryImpl(
      sl<BuildingStateRemoteDataSource>(),
    ),
  );

  sl.registerFactory<BuildingStateCubit>(
    () => BuildingStateCubit(
      repository: sl<BuildingStateRepositoryImpl>(),
    ),
  );
}