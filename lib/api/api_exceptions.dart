import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class AuthenticationException extends ApiException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class AuthorizationException extends ApiException {
  const AuthorizationException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class NotFoundException extends ApiException {
  const NotFoundException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class ApiExceptionHandler {
  static ApiException handleDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          message: 'Request timeout. Please check your internet connection and try again.',
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(dioException);

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Connection failed. Please check your internet connection.',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Certificate verification failed.',
        );

      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: dioException.message ?? 'An unexpected error occurred',
        );
    }
  }

  static ApiException _handleStatusCode(DioException dioException) {
    final statusCode = dioException.response?.statusCode;
    final data = dioException.response?.data;
    String message = 'An error occurred';

    // Try to extract message from response data
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message.isEmpty ? 'Bad request. Please check your input.' : message,
          statusCode: statusCode,
          data: data,
        );

      case 401:
        return AuthenticationException(
          message: message.isEmpty ? 'Authentication failed. Please login again.' : message,
          statusCode: statusCode,
          data: data,
        );

      case 403:
        return AuthorizationException(
          message: message.isEmpty ? 'You don\'t have permission to access this resource.' : message,
          statusCode: statusCode,
          data: data,
        );

      case 404:
        return NotFoundException(
          message: message.isEmpty ? 'The requested resource was not found.' : message,
          statusCode: statusCode,
          data: data,
        );

      case 422:
        return ValidationException(
          message: message.isEmpty ? 'Validation failed. Please check your input.' : message,
          statusCode: statusCode,
          data: data,
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message.isEmpty ? 'Server error. Please try again later.' : message,
          statusCode: statusCode,
          data: data,
        );

      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
    }
  }
}