import 'package:fpdart/fpdart.dart';
import 'package:weather_poc/scr/weather/domain/entities/weather_entity.dart';

import '../../../../core/error/failure.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather({required String location});
}
