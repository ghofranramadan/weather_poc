import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../base/depindancy_injection.dart';
import '../../common/config.dart';
import '../../common/enums/response_type_enum.dart';
import '../../error/error_handler.dart';
import '../../error/failure.dart';


abstract class NetworkService {
  Future<Either<Failure, Response>> get(
      String url, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        ResponseTypeEnum? responseType,
        String? baseUrl,
      });

  Future<Either<Failure, Response>> post(
      String url,
      dynamic data, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        ResponseTypeEnum? responseType,
        String? baseUrl,
      });

  Future<Either<Failure, Response>> put(
      String url,
      dynamic data, {
        Map<String, dynamic>? headers,
        String? baseUrl,
      });

  Future<Either<Failure, Response>> delete(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        String? baseUrl,
      });

  Future<Either<Failure, Response>> download(
      String url,
      dynamic savePath, {
        Map<String, dynamic>? headers,
        dynamic data,
        String? baseUrl,
      });

  void removeValueFromHeader({
    required String key,
  });

  void setValueToHeader({
    required String key,
    required String value,
  });
}

class NetworkServiceImpl implements NetworkService {
  final Dio dio = sl<Dio>();

  @override
  Future<Either<Failure, Response>> get(
      String url, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        ResponseTypeEnum? responseType,
        String? baseUrl,
      }) {
    return _request(
          () => dio.get(
        '${baseUrl ?? Config.baseUrl}$url',
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          responseType: _getResponseType(responseType),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Response>> post(
      String url,
      dynamic data, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        ResponseTypeEnum? responseType,
        String? baseUrl,
      }) {
    return _request(
          () => dio.post(
        '${baseUrl ?? Config.baseUrl}$url',
        queryParameters: queryParams,
        data: data,
        options: Options(
          headers: headers,
          responseType: _getResponseType(responseType),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Response>> put(
      String url,
      dynamic data, {
        Map<String, dynamic>? headers,
        String? baseUrl,
      }) {
    return _request(
          () => dio.put(
        '${baseUrl ?? Config.baseUrl}$url',
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<Failure, Response>> delete(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? headers,
        String? baseUrl,
      }) {
    return _request(
          () => dio.delete(
        '${baseUrl ?? Config.baseUrl}$url',
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<Failure, Response>> download(
      String url,
      dynamic savePath, {
        Map<String, dynamic>? headers,
        dynamic data,
        String? baseUrl,
      }) {
    return _request(
          () => dio.download(
        '${baseUrl ?? Config.baseUrl}$url',
        savePath,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Either<Failure, Response>> _request(
      Future<Response> Function() request,
      ) async {
    try {
      final response = await request();

      return Right(response);
    } on DioException catch (e) {
      return Left(
        Failure(
          ResponseError.getMessage(e),
          code: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(
        Failure(
          ResponseError.getMessage(e),
        ),
      );
    }
  }

  ResponseType _getResponseType(
      ResponseTypeEnum? responseType,
      ) {
    return responseType == ResponseTypeEnum.bytes
        ? ResponseType.bytes
        : ResponseType.json;
  }

  @override
  void removeValueFromHeader({
    required String key,
  }) {
    dio.options.headers.remove(key);
  }

  @override
  void setValueToHeader({
    required String key,
    required String value,
  }) {
    dio.options.headers[key] = value;
  }
}