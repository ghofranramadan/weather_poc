import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../scr/weather/data/datasource/weather_local_data_source.dart';
import '../../scr/weather/data/datasource/weather_remote_data_source.dart';
import '../../scr/weather/data/repository/weather_repository_impl.dart';
import '../../scr/weather/domain/repository/Weather_repository.dart';
import '../../scr/weather/domain/usecases/weather_usecase.dart';
import '../../scr/weather/presentation/controller/weather_view_model.dart';
import '../common/config.dart';
import '../util/api_interceptor/api_interceptor.dart';
import '../util/database_manager.dart';
import '../util/localization/cubit/localization_cubit.dart';
import '../util/network/network_info.dart';
import '../util/network/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Localization ──────────────────────────────────────────────────────────
  sl.registerFactory(() => LocalizationCubit());

  // ── Network ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnection>()),
  );
  sl.registerLazySingleton(
    () => InternetConnection.createInstance(),
  );
  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl(sl()));
  sl.registerLazySingleton(
    () => Dio(BaseOptions(headers: Config.headers))
      ..interceptors.add(ApiInterceptor()),
  );

  // ── Database ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DatabaseManager>(() => DatabaseManagerImpl());

  // ── View Models ───────────────────────────────────────────────────────────
  sl.registerFactory(() => WeatherViewModel(useCase: sl()));

  // ── Use Cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => WeatherUseCase(sl()));

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImp(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sl()),
  );
}

