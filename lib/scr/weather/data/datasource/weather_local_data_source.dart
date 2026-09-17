import '../models/weather_db_model.dart';
import '../../../../core/util/database_manager.dart';
import 'package:sqflite/sqflite.dart';

abstract class WeatherLocalDataSource {
  Future<void> insertWeather(WeatherDbModel model);
  Future<void> deleteWeather();
  Future<WeatherDbModel?> getStoredWeather();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final DatabaseManager _databaseManager;

  WeatherLocalDataSourceImpl(this._databaseManager);

  @override
  Future<void> insertWeather(WeatherDbModel model) async {
    final db = await _databaseManager.database;
    await db.insert(
      'weather',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteWeather() async {
    final db = await _databaseManager.database;
    await db.delete('weather');
  }

  @override
  Future<WeatherDbModel?> getStoredWeather() async {
    final db = await _databaseManager.database;
    final List<Map<String, dynamic>> maps = await db.query('weather');
    if (maps.isNotEmpty) {
      return WeatherDbModel.fromMap(maps.first);
    }
    return null;
  }
}
