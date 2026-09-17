import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseManager {
  Future<Database> get database;
}

class DatabaseManagerImpl implements DatabaseManager {
  Database? _db;

  @override
  Future<Database> get database async {
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
}
