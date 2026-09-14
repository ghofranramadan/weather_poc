import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weather_poc/core/base/route_generator.dart';
import '../../scr/weather/data/datasource/weather_remote_data_source.dart';
import '../../scr/weather/data/repository/weather_repository_impl.dart';
import '../../scr/weather/domain/repository/Weather_repository.dart';
import '../../scr/weather/domain/usecases/weather_usecase.dart';
import '../../scr/weather/presentation/controller/weather_view_model.dart';
import '../common/config.dart';
import '../util/api_interceptor/api_interceptor.dart';
import '../util/localization/cubit/localization_cubit.dart';
import '../util/network/network_info.dart';
import '../util/network/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RouteGenerator(routs: sl()));
  sl.registerFactory(() => LocalizationCubit());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnection>()),
  );
  sl.registerLazySingleton(
    () => InternetConnection.createInstance(),
  );
  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl());
  sl.registerLazySingleton(
    () =>
        Dio(BaseOptions(headers: Config.headers))
          ..interceptors.add(ApiInterceptor()),
  );

  /// VIEW MODELS
  sl.registerFactory(() => WeatherViewModel(useCase: sl(), networkInfo: sl()));

  /// USECASES
  sl.registerLazySingleton(() => WeatherUseCase(sl()));

  /// REPOSITORIES
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImp(dataSource: sl(), networkInfo: sl()),
  );

  /// DATA SOURCE
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(sl()),
  );
}
