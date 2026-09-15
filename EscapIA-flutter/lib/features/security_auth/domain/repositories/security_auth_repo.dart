abstract class AuthRepository {
  Future<String> login({
    required String phoneNumber,
    required String password,
  });
}