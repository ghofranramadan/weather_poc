import 'package:fpdart/fpdart.dart';
import 'package:weather_poc/core/util/constants.dart';

import '../../../../core/util/network/network_service.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/util/api_routes.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<Either<Failure, WeatherModel>> getWeather({required String location});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final NetworkService networkService;

  WeatherRemoteDataSourceImpl(this.networkService);
  @override
  Future<Either<Failure, WeatherModel>> getWeather({
    required String location,
  }) async {
    final response = await networkService.get(
      ApiRoutes.weather,
      queryParams: {"key": Constants.apiKey, "q": location},
    );
    return response.flatMap((response) {
      if (response.statusCode != 200) {
        return left(
          Failure(
            response.data?['error']?['message'] ??
                'Something went wrong, please try again!',
            code: response.statusCode,
          ),
        );
      }
      try {
        return Right(WeatherModel.fromJson(response.data));
      } catch (e) {
        return Left(Failure('Invalid response data'));
      }
    });
  }
}
