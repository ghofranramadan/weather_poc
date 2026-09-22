import 'package:flutter/material.dart';
import '../../scr/weather/presentation/screens/weather_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case WeatherScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const WeatherScreen(),
          settings: const RouteSettings(name: WeatherScreen.routeName),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
