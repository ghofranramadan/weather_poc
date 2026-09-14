import 'dart:io';

import 'package:dio/dio.dart';

class ResponseError {
  const ResponseError._();

  static String getMessage(Object error) {
    if (error is SocketException) {
      return 'Check your internet connection!';
    }

    if (error is DioException) {
      return _getDioMessage(error);
    }

    return 'Something went wrong, please try again!';
  }

  static String _getDioMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      final message = _extractMessage(data);

      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionError:
        return 'Check your internet connection!';

      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with API server';

      case DioExceptionType.sendTimeout:
        return 'Send timeout with server';

      case DioExceptionType.receiveTimeout:
        return 'Receive timeout with API server';

      case DioExceptionType.badCertificate:
        return 'Something went wrong, please try again!';

      case DioExceptionType.badResponse:
        return 'Something went wrong, please try again!';

      case DioExceptionType.cancel:
        return 'Request to API server was cancelled';

      case DioExceptionType.unknown:
        return 'Something went wrong, please try again!';

      case DioExceptionType.transformTimeout:
        return 'Transform timeout with API server';
    }
  }

  static String? _extractMessage(Map data) {
    final errors = data['errors'];

    if (errors is List && errors.isNotEmpty) {
      final firstError = errors.first;

      if (firstError is Map && firstError['message'] != null) {
        return firstError['message'].toString();
      }
    }

    if (data['message'] != null) {
      return data['message'].toString();
    }

    if (data['error'] != null) {
      return data['error'].toString();
    }

    return null;
  }
}
