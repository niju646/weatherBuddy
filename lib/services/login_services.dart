import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_buddy/urls/baseurl.dart';

class LoginServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Urls.backend,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      followRedirects: true,
      headers: {'Content-Type': 'application/json'},
    ),
  );
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = response.data;

      // Store tokens and user data in secure storage
      await _secureStorage.write(key: 'auth_token', value: data['accessToken']);
      await _secureStorage.write(
        key: 'refresh_token',
        value: data['refreshToken'],
      );
      await _secureStorage.write(key: 'username', value: username);
      await _secureStorage.write(key: 'email', value: data['email'] ?? '');

      print("✅ Login successful and tokens stored");
    } else {
      throw Exception("Login failed with status code: ${response.statusCode}");
    }
  }

  Future<void> signup(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        'auth/signup',
        data: {'username': username, 'email': email, 'password': password},
      );

      final data = response.data;

      if (response.statusCode == 201 && data['token'] != null) {
        await _secureStorage.write(key: 'auth_token', value: data['token']);
        await _secureStorage.write(key: 'username', value: data['username']);
        await _secureStorage.write(key: 'email', value: data['email']);
        log("✅ Signup successful. Token stored.");
      } else {
        throw Exception("Signup failed: No token in response");
      }
    } catch (e) {
      log("Signup error: $e");
      rethrow;
    }
  }

  static Future<void> logout() async {
    await _secureStorage.deleteAll();
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) return;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'];
      await _secureStorage.write(key: 'accessToken', value: newAccessToken);
    } catch (e) {
      log("Refresh token failed: $e");
    }
  }

  static Future<String?> getAccessToken() =>
      _secureStorage.read(key: 'accessToken');
}
