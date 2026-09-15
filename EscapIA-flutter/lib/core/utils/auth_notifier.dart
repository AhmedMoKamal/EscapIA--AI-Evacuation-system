import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends ChangeNotifier {
  static const String _tokenKey = 'access_token';

  final FlutterSecureStorage _storage;
  bool _isLoggedIn = false;

  AuthNotifier({required FlutterSecureStorage storage}) : _storage = storage;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> restoreSession() async {
    final token = await _storage.read(key: _tokenKey);
    _isLoggedIn = token != null && token.isNotEmpty;
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners(); 
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}