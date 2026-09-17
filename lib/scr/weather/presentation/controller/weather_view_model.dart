import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/weather_usecase.dart';

/// SRP: only responsible for weather-related UI state and calling the use-case.
/// DIP: depends on WeatherUseCase abstraction; no direct coupling to Flutter UI
///      framework concepts (BuildContext / AppLocalizations removed).
class WeatherViewModel {
  final WeatherUseCase useCase;

  WeatherViewModel({required this.useCase});

  TextEditingController searchController = TextEditingController();
  final Debouncer debouncer = Debouncer();

  GenericCubit<WeatherEntity> weatherDetails = GenericCubit(const WeatherEntity());

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

  /// [emptyErrorMessage] is resolved by the UI layer (e.g. from AppLocalizations)
  /// so the ViewModel never needs a BuildContext.
  Future<void> getWeatherData({
    required String value,
    required String emptyErrorMessage,
  }) async {
    if (value.isEmpty) {
      weatherDetails.onErrorState(Failure(emptyErrorMessage));
      return;
    }
    await getWeather();
  }
}

