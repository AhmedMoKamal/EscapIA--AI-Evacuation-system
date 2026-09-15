import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:escapia/features/incidents/data/datasources/incidents_remote_data_sourec.dart';
import 'package:escapia/features/incidents/data/repositories/incidents_repo_impl.dart';
import 'package:escapia/features/incidents/presentation/cubits/incident_cubit/incidents_cubit.dart';

import 'package:escapia/features/incidents/data/datasources/report_data_source.dart';
import 'package:escapia/features/incidents/data/repositories/report_repo_impl.dart';
import 'package:escapia/features/incidents/presentation/cubits/report_cubit/report_cubit.dart';

void initIncidentsInjection(GetIt sl) {
  sl.registerLazySingleton<IncidentsRemoteDataSource>(
    () => IncidentsRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<IncidentsRepositoryImpl>(
    () => IncidentsRepositoryImpl(
      remoteDataSource: sl<IncidentsRemoteDataSource>(),
    ),
  );

  sl.registerFactory<IncidentsCubit>(
    () => IncidentsCubit(
      repository: sl<IncidentsRepositoryImpl>(),
    ),
  );
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSource(sl<Dio>()),
  );

  sl.registerLazySingleton<ReportRepoImpl>(
    () => ReportRepoImpl(
      sl<ReportRemoteDataSource>(),
    ),
  );

  sl.registerFactory<ReportCubit>(
    () => ReportCubit(
      repository: sl<ReportRepoImpl>(),
    ),
  );
}