// import 'package:dio/dio.dart';
//
// import '../base/depindancy_injection.dart';
// import '../common/config.dart';
// import '../common/enums/response_type_enum.dart';
//
// abstract class NetworkService {
//   Future<Response> get(
//     String url, {
//     Map<String, dynamic>? queryParams,
//     Map<String, dynamic>? headers,
//     ResponseTypeEnum? responseType,
//     String? baseUrl,
//   });
//   Future<Response> post(
//     String url,
//     dynamic data, {
//     Map<String, dynamic>? queryParams,
//     Map<String, dynamic>? headers,
//     ResponseTypeEnum? responseType,
//     String? baseUrl,
//   });
//   Future<Response> delete(
//     String url, {
//     dynamic data,
//     Map<String, dynamic>? queryParams,
//     Map<String, dynamic>? headers,
//     String? baseUrl,
//   });
//
//   Future<Response> put(
//     String url,
//     dynamic data, {
//     Map<String, dynamic>? headers,
//     String? baseUrl,
//   });
//   Future<Response> download(
//     String url,
//     dynamic savePath, {
//     Map<String, dynamic>? headers,
//     dynamic data,
//     String? baseUrl,
//   });
//   removeValueFromHeader({required String key});
//   setValueToHeader({required String key, required String value});
// }
//
// class NetworkServiceImpl implements NetworkService {
//   final dio = sl<Dio>();
//   @override
//   Future<Response> get(
//     String url, {
//     Map<String, dynamic>? queryParams,
//     Map<String, dynamic>? headers,
//     ResponseTypeEnum? responseType,
//     String? baseUrl,
//   }) async {
//     try {
//       final Response response = await dio.get(
//         "${baseUrl ?? Config.baseUrl}$url",
//         queryParameters: queryParams,
//         options: Options(
//           headers: headers,
//           responseType:
//               responseType == ResponseTypeEnum.bytes
//                   ? ResponseType.bytes
//                   : ResponseType.json,
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         return e.response!;
//       } else {
//         return Response(
//           requestOptions: RequestOptions(path: url),
//           statusCode: 500,
//           statusMessage: e.message ?? "Unknown Dio Error",
//         );
//       }
//     }
//   }
//
//   @override
//   Future<Response> post(
//     String url,
//     dynamic data, {
//     Map<String, dynamic>? queryParams,
//     Map<String, dynamic>? headers,
//     ResponseTypeEnum? responseType,
//     String? baseUrl,
//   }) async {
//     final response = await dio.post(
//       "${baseUrl ?? Config.baseUrl}$url",
//       queryParameters: queryParams,
//       data: data,
//       options: Options(
//         headers: headers,
//         responseType:
//             (responseType == ResponseTypeEnum.bytes)
//                 ? ResponseType.bytes
//                 : ResponseType.json,
//       ),
//     );
//     return response;
//   }
//
//   @override
//   Future<Response> put(
//     String url,
//     dynamic data, {
//     Map<String, dynamic>? headers,
//     String? baseUrl,
//   }) async {
//     final response = await dio.put(
//       "${baseUrl ?? Config.baseUrl}$url",
//       data: data,
//       options: Options(headers: headers),
//     );
//     return response;
//   }
//
//   @override
//   Future<Response> download(
//     String url,
//     savePath, {
//     Map<String, dynamic>? headers,
//     data,
//     String? baseUrl,
//   }) async {
//     final response = await dio.download(
//       "${baseUrl ?? Config.baseUrl}$url",
//       savePath,
//       data: data,
//       options: Options(headers: headers),
//     );
//     return response;
//   }
//
//   @override
//   Future<Response> delete(
//     String url, {
//     data,
//     Map<String, dynamic>? queryParams,
//     Map<String, dynamic>? headers,
//     String? baseUrl,
//   }) async {
//     final response = await dio.delete(
//       "${baseUrl ?? Config.baseUrl}$url",
//       queryParameters: queryParams,
//       data: data,
//       options: Options(headers: headers),
//     );
//     return response;
//   }
//
//   @override
//   removeValueFromHeader({required String key}) =>
//       dio.options.headers.remove(key);
//
//   @override
//   setValueToHeader({required String key, required String value}) =>
//       dio.options.headers[key] = value;
// }
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