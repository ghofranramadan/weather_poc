import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final LocationEntity? location;
  final CurrentEntity? current;

  const WeatherEntity({this.location, this.current});

  @override
  List<Object?> get props => [location, current];
}

class LocationEntity extends Equatable {
  final String? name;

  const LocationEntity({this.name});

  @override
  List<Object?> get props => [name];
}

class CurrentEntity extends Equatable {
  final String? lastUpdated;
  final double? tempC;
  final double? tempF;
  final ConditionEntity? condition;
  const CurrentEntity({
    this.lastUpdated,
    this.tempC,
    this.tempF,
    this.condition,
  });

  @override
  List<Object?> get props => [lastUpdated, tempC, tempF, condition];
}

class ConditionEntity extends Equatable {
  final String? text;
  final String? icon;

  const ConditionEntity({this.text, this.icon});

  @override
  List<Object?> get props => [text, icon];
}
