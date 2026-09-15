import 'package:escapia/features/security_auth/data/datasources/security_auth_data_source.dart';
import 'package:escapia/features/security_auth/domain/repositories/security_auth_repo.dart';
import 'package:escapia/core/network/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    TokenStorage? tokenStorage,
  }) : tokenStorage = tokenStorage ?? TokenStorage(storage: secureStorage);

  @override
  Future<String> login({
    required String phoneNumber,
    required String password,
  }) async {
    final token = await remoteDataSource.login(
      phoneNumber: phoneNumber,
      password: password,
    );

    await tokenStorage.saveToken(token);

    return token;
  }
}