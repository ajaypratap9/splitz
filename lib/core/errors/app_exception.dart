class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException(code: $code, message: $message)';

  factory AppException.fromSupabase(dynamic error) {
    if (error is Map) {
      return AppException(
        message: error['message']?.toString() ?? 'Unknown error',
        code: error['code']?.toString(),
        details: error,
      );
    }
    return AppException(message: error.toString());
  }
}

class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection', super.code});
}

class ServerException extends AppException {
  const ServerException({required super.message, super.code, super.details});
}

class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code,
  });
}
