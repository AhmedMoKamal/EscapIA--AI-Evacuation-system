import 'package:escapia/features/settings/domain/repositories/profile_repo.dart';
import '../../domain/entities/profile_entity.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile() async {
    return await remoteDataSource.getProfile();
  }
}