import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:auth_ui_app/utils/constants/api_constants.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final GetStorage _storage = GetStorage();

  /// Attempt login to Laravel HRM API
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Demo login for testing (admin@gmail.com / 1234)
    if (email.trim().toLowerCase() == 'admin@gmail.com' && password == '1234') {
      final demoUser = {
        'id': 1,
        'name': 'System Administrator',
        'email': 'admin@gmail.com',
        'role': 'HR Admin & Manager',
        'designation': 'Enterprise Administrator',
        'is_demo': true,
      };
      const demoToken = 'demo_laravel_hrm_token_admin_1234';
      await _saveSession(token: demoToken, user: demoUser);
      return {
        'success': true,
        'message': 'Logged in as Administrator (Demo Mode)',
        'token': demoToken,
        'user': demoUser,
      };
    }

    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      if (kDebugMode) {
        print("Authenticating with Laravel HRM at: ${ApiConstants.loginEndpoint}");
      }

      final response = await http
          .post(
            Uri.parse(ApiConstants.loginEndpoint),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      final dynamic responseData = jsonDecode(response.body);

      // Handle 200 OK / 201 Created
      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = '';
        Map<String, dynamic> user = {};

        if (responseData is Map<String, dynamic>) {
          // Token discovery across standard Laravel formats
          if (responseData['token'] != null) {
            token = responseData['token'].toString();
          } else if (responseData['access_token'] != null) {
            token = responseData['access_token'].toString();
          } else if (responseData['data'] is Map && responseData['data']['token'] != null) {
            token = responseData['data']['token'].toString();
          }

          // User info discovery
          if (responseData['user'] is Map<String, dynamic>) {
            user = responseData['user'];
          } else if (responseData['data'] is Map && responseData['data']['user'] is Map<String, dynamic>) {
            user = responseData['data']['user'];
          } else if (responseData['data'] is Map<String, dynamic>) {
            user = responseData['data'];
          } else {
            user = {
              'name': email.split('@').first,
              'email': email,
              'role': 'Employee',
            };
          }
        }

        // Save session locally
        await _saveSession(token: token, user: user);

        return {
          'success': true,
          'message': responseData['message'] ?? 'Login successful',
          'token': token,
          'user': user,
        };
      }

      // Handle 401 Unauthorized / 422 Validation Error
      String errorMessage = 'Invalid credentials. Please verify your email and password.';
      if (responseData is Map<String, dynamic>) {
        if (responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        } else if (responseData['error'] != null) {
          errorMessage = responseData['error'].toString();
        } else if (responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;
          errorMessage = errors.values.map((e) => (e is List) ? e.join(' ') : e.toString()).join('\n');
        }
      }

      return {
        'success': false,
        'message': errorMessage,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      if (kDebugMode) {
        print("Auth error: $e");
      }

      // Check if it's a network/DNS error or server unavailable
      return {
        'success': false,
        'message': 'Connection error to ${ApiConstants.baseUrl}. Please check your network or server availability.',
        'error': e.toString(),
      };
    }
  }

  /// Save Auth Session to GetStorage
  Future<void> _saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await _storage.write(ApiConstants.storageTokenKey, token);
    await _storage.write(ApiConstants.storageUserKey, user);
    await _storage.write(ApiConstants.storageIsLoggedInKey, true);
  }

  /// Check if user is already logged in
  bool isLoggedIn() {
    return _storage.read<bool>(ApiConstants.storageIsLoggedInKey) ?? false;
  }

  /// Get active bearer token
  String? getToken() {
    return _storage.read<String>(ApiConstants.storageTokenKey);
  }

  /// Get current user data
  Map<String, dynamic>? getUser() {
    final data = _storage.read(ApiConstants.storageUserKey);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Logout and clear credentials
  Future<void> logout() async {
    try {
      final token = getToken();
      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse(ApiConstants.logoutEndpoint),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 5));
      }
    } catch (_) {}

    await _storage.remove(ApiConstants.storageTokenKey);
    await _storage.remove(ApiConstants.storageUserKey);
    await _storage.write(ApiConstants.storageIsLoggedInKey, false);
  }
}
