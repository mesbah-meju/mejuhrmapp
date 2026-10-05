import 'dart:math';

enum SyncOperationStatus {
  pending,
  syncing,
  retryWaiting,
  synced,
  failed,
  blocked,
  cancelled,
}

class SyncResult {
  final bool isSuccess;
  final bool isRetryable;
  final String? message;
  final String? errorCode;
  final int? statusCode;
  final Map<String, dynamic>? data;

  const SyncResult({
    required this.isSuccess,
    this.isRetryable = false,
    this.message,
    this.errorCode,
    this.statusCode,
    this.data,
  });

  factory SyncResult.success({String? message, Map<String, dynamic>? data}) {
    return SyncResult(
      isSuccess: true,
      isRetryable: false,
      message: message ?? 'Synchronized successfully',
      data: data,
    );
  }

  factory SyncResult.retryableFailure({
    required String message,
    String? errorCode,
    int? statusCode,
  }) {
    return SyncResult(
      isSuccess: false,
      isRetryable: true,
      message: message,
      errorCode: errorCode ?? 'network_temporary_error',
      statusCode: statusCode,
    );
  }

  factory SyncResult.permanentFailure({
    required String message,
    String? errorCode,
    int? statusCode,
  }) {
    return SyncResult(
      isSuccess: false,
      isRetryable: false,
      message: message,
      errorCode: errorCode ?? 'permanent_error',
      statusCode: statusCode,
    );
  }
}

class SyncRetryPolicy {
  static const int defaultMaxRetries = 5;

  /// Calculate next retry duration using exponential backoff with jitter
  /// Retry 1: ~5s, Retry 2: ~15s, Retry 3: ~60s, Retry 4: ~300s (5m), Retry 5: Final
  static DateTime calculateNextRetryTime({required int currentRetryCount}) {
    final baseSeconds = switch (currentRetryCount) {
      0 => 5,
      1 => 15,
      2 => 60,
      3 => 300,
      _ => 600,
    };

    // Add jitter (-20% to +20%) to avoid thunderous herd problem
    final random = Random();
    final jitterFactor = 0.8 + (random.nextDouble() * 0.4);
    final finalSeconds = (baseSeconds * jitterFactor).round();

    return DateTime.now().add(Duration(seconds: finalSeconds));
  }

  /// Classify if an HTTP status code or error is retryable
  static bool isRetryableStatus(int statusCode) {
    if (statusCode == 0) return true; // Socket/Network connection failure
    if (statusCode == 408) return true; // Request timeout
    if (statusCode == 429) return true; // Rate limit
    if (statusCode >= 500 && statusCode <= 599) return true; // 500, 502, 503, 504
    return false; // 400, 401, 403, 404, 409, 422 are non-retryable
  }
}
