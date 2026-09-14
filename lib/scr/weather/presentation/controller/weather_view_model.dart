import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/util/db_helper.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../../core/util/network/network_info.dart';
import '../../data/models/weather_db_model.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/weather_usecase.dart';

class WeatherViewModel {
  final WeatherUseCase useCase;
  final NetworkInfo networkInfo;

  WeatherViewModel({required this.useCase, required this.networkInfo});

  TextEditingController searchController = TextEditingController();
  final Debouncer debouncer = Debouncer();

  GenericCubit<WeatherEntity> weatherDetails = GenericCubit(WeatherEntity());
  Future<void> getWeather() async {
    weatherDetails.onLoadingState();
    final response = await useCase.getWeather(location: searchController.text);
    response.fold(
      (failure) {
        weatherDetails.onErrorState(failure);
      },
      (data) {
        weatherDetails.onUpdateData(data);
      },
    );
  }

  Future<void> getWeatherData({
    required BuildContext context,
    required String value,
  }) async {
    weatherDetails.onLoadingState();
    if (!await networkInfo.isConnected) {
      showNoInternetDialog(context);
      await _loadCachedWeather(context);
      return;
    }

    if (value.isEmpty) {
      weatherDetails.onErrorState(
        Failure(AppLocalizations.of(context)!.translate('no_data_found')),
      );
      return;
    }
    _fetchAndCacheWeather(context);
  }

  Future<void> _fetchAndCacheWeather(BuildContext context) async {
    try {
      await getWeather();
      final data = weatherDetails.state.data;
      await DBHelper.deleteWeather();
      await DBHelper.insertWeather(
        WeatherDbModel(
          name: data.location?.name,
          lastUpdated: data.current?.lastUpdated,
          tempC: data.current?.tempC,
          tempF: data.current?.tempF,
          conditionText: data.current?.condition?.text,
          conditionIcon: data.current?.condition?.icon,
        ),
      );
    } catch (e) {
      weatherDetails.onErrorState(
        Failure(AppLocalizations.of(context)!.translate('fetch_error')),
      );
    }
  }

  Future<void> _loadCachedWeather(BuildContext context) async {
    try {
      final cached = await DBHelper.getStoredWeather();
      if (cached == null) {
        weatherDetails.onErrorState(
          Failure(
            AppLocalizations.of(
              context,
            )!.translate('no_connection_or_data_stored'),
          ),
        );
        return;
      }
      weatherDetails.onUpdateData(
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
    } catch (e) {
      weatherDetails.onErrorState(
        Failure(AppLocalizations.of(context)!.translate('load_cache_failed')),
      );
    }
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('no_internet_connection'),
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('check_internet'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate('ok')),
            ),
          ],
        );
      },
    );
  }
}
