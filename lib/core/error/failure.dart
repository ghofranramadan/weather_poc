// import 'package:dio/dio.dart';
//
// class Failure extends DioException {
//   final String errorMessage;
//   final int? code;
//   Failure(this.errorMessage, {this.code})
//       : super(requestOptions: RequestOptions(path: ''));
//
//   @override
//   String toString() {
//     return errorMessage;
//   }
// }
class Failure {
  final String errorMessage;
  final int? code;

  const Failure(
      this.errorMessage, {
        this.code,
      });

  @override
  String toString() => errorMessage;
}