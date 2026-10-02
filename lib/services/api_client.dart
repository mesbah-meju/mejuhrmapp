import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:auth_ui_app/utils/constants/api_constants.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final dynamic errors;
  final int statusCode;
  final dynamic rawJson;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    required this.statusCode,
    this.rawJson,
  });

  bool get isSuccess => success && (statusCode >= 200 && statusCode < 300);
}

class ApiClient {
  static final ApiClient instance = ApiClient._internal();
  ApiClient._internal();

  final GetStorage _storage = GetStorage();
  final http.Client _client = http.Client();

  /// Retrieve bearer token from local storage
  String? get token => _storage.read<String>(ApiConstants.storageTokenKey);

  /// Standard Request Headers
  Map<String, String> get headers {
    final Map<String, String> map = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final currentToken = token;
    if (currentToken != null && currentToken.isNotEmpty) {
      map['Authorization'] = 'Bearer $currentToken';
    }
    return map;
  }

  /// GET Request
  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, String>? queryParams,
    T Function(dynamic json)? fromJson,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    Uri uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    if (kDebugMode) {
      print("[API GET] -> $uri");
    }

    try {
      final response = await _client.get(uri, headers: headers).timeout(timeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e, url);
    }
  }

  /// POST Request
  Future<ApiResponse<T>> post<T>(
    String url, {
    dynamic body,
    T Function(dynamic json)? fromJson,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final uri = Uri.parse(url);

    if (kDebugMode) {
      print("[API POST] -> $uri");
      if (body != null) print("[API Payload] -> ${jsonEncode(body)}");
    }

    try {
      final encodedBody = body != null ? jsonEncode(body) : null;
      final response = await _client.post(uri, headers: headers, body: encodedBody).timeout(timeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e, url);
    }
  }

  /// PUT Request
  Future<ApiResponse<T>> put<T>(
    String url, {
    dynamic body,
    T Function(dynamic json)? fromJson,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final uri = Uri.parse(url);

    try {
      final encodedBody = body != null ? jsonEncode(body) : null;
      final response = await _client.put(uri, headers: headers, body: encodedBody).timeout(timeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e, url);
    }
  }

  /// DELETE Request
  Future<ApiResponse<T>> delete<T>(
    String url, {
    dynamic body,
    T Function(dynamic json)? fromJson,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final uri = Uri.parse(url);

    try {
      final encodedBody = body != null ? jsonEncode(body) : null;
      final response = await _client.delete(uri, headers: headers, body: encodedBody).timeout(timeout);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e, url);
    }
  }

  /// Process HTTP Response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic json)? fromJson,
  ) {
    final statusCode = response.statusCode;
    if (kDebugMode) {
      print("[API Response ${response.request?.url}] StatusCode: $statusCode");
      print("[API Body] ${response.body}");
    }

    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);
    } catch (_) {
      responseBody = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      String message = 'Success';
      dynamic dataNode = responseBody;

      if (responseBody is Map<String, dynamic>) {
        message = responseBody['message']?.toString() ?? 'Success';
        if (responseBody.containsKey('data')) {
          dataNode = responseBody['data'];
        }
      }

      T? parsedData;
      if (fromJson != null && dataNode != null) {
        parsedData = fromJson(dataNode);
      } else if (dataNode is T) {
        parsedData = dataNode;
      }

      return ApiResponse<T>(
        success: true,
        message: message,
        data: parsedData,
        statusCode: statusCode,
        rawJson: responseBody,
      );
    }

    // Handle 400, 401, 403, 422, 500
    String errorMessage = 'Request failed with status code $statusCode';
    dynamic errors;

    if (responseBody is Map<String, dynamic>) {
      if (responseBody['message'] != null) {
        errorMessage = responseBody['message'].toString();
      } else if (responseBody['error'] != null) {
        errorMessage = responseBody['error'].toString();
      }

      if (responseBody['errors'] != null) {
        errors = responseBody['errors'];
        if (errors is Map) {
          final errorList = errors.values
              .map((e) => (e is List) ? e.join(' ') : e.toString())
              .toList();
          if (errorList.isNotEmpty && errorMessage == 'Request failed with status code $statusCode') {
            errorMessage = errorList.join('\n');
          }
        }
      }
    }

    return ApiResponse<T>(
      success: false,
      message: errorMessage,
      errors: errors,
      statusCode: statusCode,
      rawJson: responseBody,
    );
  }

  /// Process Network / Parsing Errors
  ApiResponse<T> _handleError<T>(dynamic error, String url) {
    if (kDebugMode) {
      print("[API Exception] for $url: $error");
    }

    String msg = "Connection error. Please check your network connection.";
    if (error is TimeoutException) {
      msg = "Request timed out. The server is taking too long to respond.";
    } else if (error != null) {
      msg = error.toString();
    }

    return ApiResponse<T>(
      success: false,
      message: msg,
      errors: error,
      statusCode: 0,
    );
  }
}
