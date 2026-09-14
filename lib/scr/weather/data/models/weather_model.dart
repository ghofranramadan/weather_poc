import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({super.location, super.current});

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    location:
        json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
    current:
        json['current'] != null ? CurrentModel.fromJson(json['current']) : null,
  );
}

class LocationModel extends LocationEntity {
  const LocationModel({super.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      LocationModel(name: json['name']);
}

class CurrentModel extends CurrentEntity {
  const CurrentModel({
    super.lastUpdated,
    super.tempC,
    super.tempF,
    super.condition,
  });

  factory CurrentModel.fromJson(Map<String, dynamic> json) => CurrentModel(
    lastUpdated: json['last_updated'],
    tempC: json['temp_c'],
    tempF: json['temp_f'],
    condition:
        json['condition'] != null
            ? ConditionModel.fromJson(json['condition'])
            : null,
  );
}

class ConditionModel extends ConditionEntity {
  const ConditionModel({super.text, super.icon});

  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      ConditionModel(text: json['text'], icon: json['icon']);
}

