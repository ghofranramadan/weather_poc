import 'package:fpdart/fpdart.dart';
import 'package:weather_poc/scr/weather/domain/entities/weather_entity.dart';

import '../../../../core/error/failure.dart';
import '../repository/Weather_repository.dart';

class WeatherUseCase {
  final WeatherRepository _repository;

  WeatherUseCase(this._repository);

  Future<Either<Failure, WeatherEntity>> getWeather({
    required String location,
  }) {
    return _repository.getWeather(location: location);
  }
}
