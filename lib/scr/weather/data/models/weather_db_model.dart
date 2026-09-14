class WeatherDbModel {
  final String? name;
  final String? lastUpdated;
  final double? tempC;
  final double? tempF;
  final String? conditionText;
  final String? conditionIcon;
  WeatherDbModel({
    this.name,
    this.lastUpdated,
    this.tempC,
    this.tempF,
    this.conditionText,
    this.conditionIcon,
  });
  factory WeatherDbModel.fromMap(Map<String, dynamic> map) => WeatherDbModel(
    name: map['name'],
    lastUpdated: map['last_updated'],
    tempC: map['temp_c'],
    tempF: map['temp_f'],
    conditionText: map['condition_text'],
    conditionIcon: map['condition_icon'],
  );
  Map<String, dynamic> toMap() => {
    'name': name,
    'last_updated': lastUpdated,
    'temp_c': tempC,
    'temp_f': tempF,
    'condition_text': conditionText,
    'condition_icon': conditionIcon,
  };
}
