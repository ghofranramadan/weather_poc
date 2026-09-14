import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    final headers = options.headers.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(' | ');

    log(
      '┌────────────────────────────────────────────────────────',
    );
    log('| Request: ${options.method} ${options.uri}');
    log('| Headers: $headers');
    log('| Body: ${options.data}');
    log(
      '└────────────────────────────────────────────────────────',
    );

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {

    String responseBody;

    try {
      responseBody = const JsonEncoder.withIndent('  ')
          .convert(response.data);
    } catch (_) {
      responseBody = response.data.toString();
    }

    log('| Status code: ${response.statusCode}');
    log('| Response: $responseBody');

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    log('| Error statusCode: ${err.response?.statusCode}');
    log('| Error type: ${err.type}');
    log('| Error response: ${err.response?.data}');

    handler.next(err);
  }
}