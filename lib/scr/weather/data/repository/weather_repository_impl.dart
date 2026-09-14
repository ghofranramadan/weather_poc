import 'package:fpdart/fpdart.dart';
import '../../domain/entities/weather_entity.dart';

import '../../../../../../core/util/network/network_info.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repository/Weather_repository.dart';
import '../datasource/weather_remote_data_source.dart';

class WeatherRepositoryImp implements WeatherRepository {
  final WeatherRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImp({required this.dataSource, required this.networkInfo});
  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required String location,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(Failure('No Internet Connection'));
    }
    return await dataSource.getWeather(location: location);
  }
}
