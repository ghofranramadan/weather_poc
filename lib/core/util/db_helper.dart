import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../scr/weather/data/models/weather_db_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    String path = join(await getDatabasesPath(), 'weather.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE weather (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            last_updated TEXT,
            temp_c REAL,
            temp_f REAL,
            condition_text TEXT,
            condition_icon TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<void> insertWeather(WeatherDbModel model) async {
    final db = await getDatabase();
    await db.insert(
      'weather',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteWeather() async {
    final db = await getDatabase();
    await db.delete('weather');
  }

  static Future<WeatherDbModel?> getStoredWeather() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('weather');
    if (maps.isNotEmpty) {
      return WeatherDbModel.fromMap(maps.first);
    }
    return null;
  }
}
