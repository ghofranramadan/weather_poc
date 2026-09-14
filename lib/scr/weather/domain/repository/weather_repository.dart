import 'package:fpdart/fpdart.dart';
import '../entities/weather_entity.dart';

import '../../../../core/error/failure.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather({required String location});
}
