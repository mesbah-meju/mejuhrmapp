import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/services/secure_storage_service.dart';
import 'package:auth_ui_app/utils/constants/api_constants.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final GetStorage _storage = GetStorage();

  /// Attempt production login to Laravel HRM API with Dual-Login Support (Manager / Staff)
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String loginType = 'staff',
    String? deviceName = 'Flutter-Mobile',
  }) async {
    try {
      if (kDebugMode) {
        print("Authenticating with Laravel HRM API as [$loginType] -> $email");
      }

      final response = await HrmApiService.instance.login(
        email: email,
        password: password,
        loginType: loginType,
        deviceName: deviceName,
      );

      if (response.isSuccess && response.data != null) {
        final authData = response.data!;

        await _saveSession(
          token: authData.token,
          user: authData.user.toJson(),
          employee: authData.employee?.toJson(),
          tenantLocations: authData.tenantLocations.map((l) => l.toJson()).toList(),
          loginType: authData.loginType,
        );

        return {
          'success': true,
          'message': response.message,
          'token': authData.token,
          'user': authData.user.toJson(),
          'employee': authData.employee?.toJson(),
          'tenant_locations': authData.tenantLocations.map((l) => l.toJson()).toList(),
          'login_type': authData.loginType,
        };
      }

      return {
        'success': false,
        'message': response.message,
        'errors': response.errors,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      if (kDebugMode) {
        print("Auth error: $e");
      }

      return {
        'success': false,
        'message': 'Unable to connect to the authentication server. Please check your network connection.',
        'error': e.toString(),
      };
    }
  }

  /// Save Auth Session to Secure Storage & local state
  Future<void> _saveSession({
    required String token,
    required Map<String, dynamic> user,
    Map<String, dynamic>? employee,
    List<dynamic>? tenantLocations,
    required String loginType,
  }) async {
    // 1. Store bearer token securely in encrypted hardware storage & persistent cache
    await SecureStorageService.instance.setToken(token);
    await _storage.write(ApiConstants.storageTokenKey, token);

    // 2. Store non-sensitive user display metadata
    await _storage.write(ApiConstants.storageUserKey, user);
    if (employee != null) {
      await _storage.write(ApiConstants.storageEmployeeKey, employee);
    }
    if (tenantLocations != null) {
      await _storage.write(ApiConstants.storageTenantLocationsKey, tenantLocations);
    }
    await _storage.write(ApiConstants.storageUserModeKey, loginType);
    await _storage.write(ApiConstants.storageIsLoggedInKey, true);
  }

  /// Check if user is already logged in
  bool isLoggedIn() {
    final token = getToken();
    final isLogged = _storage.read<bool>(ApiConstants.storageIsLoggedInKey) ?? false;
    final hasUser = getUser() != null;
    return isLogged && hasUser && (token != null && token.isNotEmpty);
  }

  /// Get active bearer token synchronously from cache if available or token key
  String? getToken() {
    return SecureStorageService.instance.cachedToken ?? _storage.read<String>(ApiConstants.storageTokenKey);
  }

  /// Get active bearer token asynchronously from encrypted SecureStorage
  Future<String?> getSecureToken() async {
    return await SecureStorageService.instance.getToken();
  }

  /// Get current user data as Map
  Map<String, dynamic>? getUser() {
    final data = _storage.read(ApiConstants.storageUserKey);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Get typed UserModel
  UserModel? getCurrentUser() {
    final rawUser = getUser();
    if (rawUser != null) {
      return UserModel.fromJson(rawUser);
    }
    return null;
  }

  /// Get current user ID (scoped for local database)
  int getCurrentUserId() {
    return getCurrentUser()?.id ?? 0;
  }

  /// Get current tenant/company ID (scoped for multi-tenant isolation)
  int getCurrentTenantId() {
    final employee = getEmployee();
    if (employee != null && employee.branch != null && employee.branch!.id > 0) {
      return employee.branch!.id;
    }
    final user = getCurrentUser();
    if (user != null && user.createdBy != null && user.createdBy! > 0) {
      return user.createdBy!;
    }
    return 1; // Default company workspace ID
  }

  /// Get Employee data as Map
  Map<String, dynamic>? getEmployeeMap() {
    final data = _storage.read(ApiConstants.storageEmployeeKey);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Get typed EmployeeModel
  EmployeeModel? getEmployee() {
    final rawEmp = getEmployeeMap();
    if (rawEmp != null) {
      return EmployeeModel.fromJson(rawEmp);
    }
    return null;
  }

  /// Get cached Tenant Locations
  List<TenantLocationModel> getTenantLocations() {
    final rawList = _storage.read<List>(ApiConstants.storageTenantLocationsKey);
    if (rawList != null) {
      return rawList
          .map((e) => TenantLocationModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }

  /// Check user roles
  bool isManager() {
    final mode = _storage.read<String>(ApiConstants.storageUserModeKey);
    if (mode == 'manager') return true;
    final user = getCurrentUser();
    if (user != null) {
      return user.roles.any((r) => ['admin', 'hr', 'manager', 'superadmin'].contains(r.toLowerCase())) ||
          ['admin', 'hr', 'manager'].contains(user.type.toLowerCase());
    }
    return false;
  }

  /// Refresh user profile from server
  Future<bool> refreshUserProfile() async {
    try {
      final response = await HrmApiService.instance.getUserProfile();
      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        await _storage.write(ApiConstants.storageUserKey, data.user.toJson());
        if (data.employee != null) {
          await _storage.write(ApiConstants.storageEmployeeKey, data.employee!.toJson());
        }
        if (data.tenantLocations.isNotEmpty) {
          await _storage.write(
            ApiConstants.storageTenantLocationsKey,
            data.tenantLocations.map((e) => e.toJson()).toList(),
          );
        }
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Logout and clear credentials
  Future<void> logout() async {
    try {
      await HrmApiService.instance.logout();
    } catch (_) {}

    await SecureStorageService.instance.clearAuthCredentials();
    await _storage.remove(ApiConstants.storageTokenKey);
    await _storage.remove(ApiConstants.storageUserKey);
    await _storage.remove(ApiConstants.storageEmployeeKey);
    await _storage.remove(ApiConstants.storageTenantLocationsKey);
    await _storage.write(ApiConstants.storageIsLoggedInKey, false);
  }
}
