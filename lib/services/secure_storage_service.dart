import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:auth_ui_app/utils/constants/api_constants.dart';

class SecureStorageService {
  static final SecureStorageService instance = SecureStorageService._internal();
  SecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    webOptions: WebOptions(dbName: 'meju_hrm_secure', publicKey: 'meju_hrm_pub'),
  );

  final Map<String, String> _memoryFallback = {};

  static const String _tokenKey = 'secure_auth_bearer_token';
  static const String _refreshTokenKey = 'secure_refresh_token';

  /// Synchronously accessible cached bearer token
  String? get cachedToken => _memoryFallback[_tokenKey] ?? GetStorage().read<String>(ApiConstants.storageTokenKey);

  /// Initialize and load stored bearer token into memory
  Future<void> initialize() async {
    try {
      // 1. Try reading from secure encrypted storage
      final secureToken = await _secureStorage.read(key: _tokenKey);
      if (secureToken != null && secureToken.isNotEmpty) {
        _memoryFallback[_tokenKey] = secureToken;
      }

      // 2. Also check fallback from persistent storage
      final getStorage = GetStorage();
      final storedToken = getStorage.read<String>(ApiConstants.storageTokenKey);
      if (storedToken != null && storedToken.isNotEmpty) {
        _memoryFallback[_tokenKey] = storedToken;
        if (secureToken == null || secureToken.isEmpty) {
          await _secureStorage.write(key: _tokenKey, value: storedToken);
        }
      }
    } catch (e) {
      if (kDebugMode) print("SecureStorage initialize warning: $e");
      final fallback = GetStorage().read<String>(ApiConstants.storageTokenKey);
      if (fallback != null && fallback.isNotEmpty) {
        _memoryFallback[_tokenKey] = fallback;
      }
    }
  }

  /// Save bearer token in encrypted hardware-backed storage & memory cache
  Future<void> setToken(String token) async {
    _memoryFallback[_tokenKey] = token;
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      if (kDebugMode) print("SecureStorage write fallback: $e");
    }
    try {
      await GetStorage().write(ApiConstants.storageTokenKey, token);
    } catch (_) {}
  }

  /// Retrieve bearer token
  Future<String?> getToken() async {
    if (_memoryFallback.containsKey(_tokenKey) && _memoryFallback[_tokenKey]!.isNotEmpty) {
      return _memoryFallback[_tokenKey];
    }

    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        _memoryFallback[_tokenKey] = token;
        return token;
      }
    } catch (e) {
      if (kDebugMode) print("SecureStorage read fallback: $e");
    }

    try {
      final fallback = GetStorage().read<String>(ApiConstants.storageTokenKey);
      if (fallback != null && fallback.isNotEmpty) {
        _memoryFallback[_tokenKey] = fallback;
        return fallback;
      }
    } catch (_) {}

    return null;
  }

  /// Save refresh token if applicable
  Future<void> setRefreshToken(String token) async {
    _memoryFallback[_refreshTokenKey] = token;
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      if (kDebugMode) print("SecureStorage write refresh token fallback: $e");
    }
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    try {
      final token = await _secureStorage.read(key: _refreshTokenKey);
      if (token != null && token.isNotEmpty) return token;
    } catch (e) {
      if (kDebugMode) print("SecureStorage read refresh token fallback: $e");
    }
    return _memoryFallback[_refreshTokenKey];
  }

  /// Delete sensitive tokens on logout
  Future<void> clearAuthCredentials() async {
    _memoryFallback.clear();
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (_) {}
    try {
      await GetStorage().remove(ApiConstants.storageTokenKey);
    } catch (_) {}
  }
}
