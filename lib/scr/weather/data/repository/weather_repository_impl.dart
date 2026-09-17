import 'package:fpdart/fpdart.dart';
import '../../domain/entities/weather_entity.dart';

import '../../../../../../core/util/network/network_info.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repository/Weather_repository.dart';
import '../datasource/weather_remote_data_source.dart';
import '../datasource/weather_local_data_source.dart';
import '../models/weather_db_model.dart';

/// SRP: each method has one clear responsibility.
/// DIP: depends on abstractions (WeatherRepository, WeatherRemoteDataSource,
///      WeatherLocalDataSource, NetworkInfo) — never on concrete classes.
class WeatherRepositoryImp implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeather({
    required String location,
  }) async {
    if (!await networkInfo.isConnected) {
      return _loadFromCache();
    }

    final response = await remoteDataSource.getWeather(location: location);
    return response.map((data) {
      _cacheWeather(data); // intentional fire-and-forget background cache
      return data;
    });
  }

  /// Loads the last-known weather from the local database.
  Future<Either<Failure, WeatherEntity>> _loadFromCache() async {
    final cached = await localDataSource.getStoredWeather();
    if (cached != null) {
      return Right(
        WeatherEntity(
          location: LocationEntity(name: cached.name),
          current: CurrentEntity(
            lastUpdated: cached.lastUpdated,
            tempC: cached.tempC,
            tempF: cached.tempF,
            condition: ConditionEntity(
              text: cached.conditionText,
              icon: cached.conditionIcon,
            ),
          ),
        ),
      );
    }
    return const Left(Failure('No connection or data stored'));
  }

  /// SRP: responsible only for writing fresh data to the local cache.
  /// Errors are caught and silenced intentionally — cache failures should not
  /// surface to the user when fresh data is already returned.
  Future<void> _cacheWeather(WeatherEntity data) async {
    try {
      await localDataSource.deleteWeather();
      await localDataSource.insertWeather(
        WeatherDbModel(
          name: data.location?.name,
          lastUpdated: data.current?.lastUpdated,
          tempC: data.current?.tempC,
          tempF: data.current?.tempF,
          conditionText: data.current?.condition?.text,
          conditionIcon: data.current?.condition?.icon,
        ),
      );
    } catch (_) {
      // Cache write failure is non-critical; fresh data was already returned.
    }
  }
}

