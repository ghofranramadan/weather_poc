import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/weather_usecase.dart';

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

