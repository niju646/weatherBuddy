import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_buddy/services/login_services.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isVisible = false;
  String? _error;
  String? _username;
  String? _email;

  bool get isLoggedin => _isLoggedIn;
  bool get isVisible => _isVisible;
  String? get error => _error;
  String? get username => _username;
  String? get email => _email;
  // bool get isChecking => _isChecking;

  final _loginService = LoginServices();
  final _secureStorage = const FlutterSecureStorage();

  void login() {
    _isLoggedIn = true;
    _username = null;
    _email = null;
    notifyListeners();
  }

  void logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'email');
    _isLoggedIn = false;
    notifyListeners();
  }

  //

  void visiblity() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  Future<bool> loginAuth(String username, String password) async {
    try {
      await _loginService.login(username, password);
      await checkLoginStatus();
      _isLoggedIn = true;
      _username = await _secureStorage.read(key: 'username');
      _email = await _secureStorage.read(key: 'email');
      // _email = email;

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signupAuth(
    String username,
    String email,
    String password,
  ) async {
    try {
      await _loginService.signup(username, email, password);
      await checkLoginStatus();
      _username = await _secureStorage.read(key: 'username');
      _email = await _secureStorage.read(key: 'email');
      // _isLoggedIn = true;
      _username = username;
      _email = email;
      _error = null;
      notifyListeners();
      // return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      // return false;
    }
  }

  Future<void> checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'auth_token');
    _username = await _secureStorage.read(key: 'username');
    _email = await _secureStorage.read(key: 'email');
    _isLoggedIn = token != null;
    log("⏩⏩ token is: $token");
    log('✅ Token exists: $_isLoggedIn');
    // _isChecking = false;
    notifyListeners();
  }
}
