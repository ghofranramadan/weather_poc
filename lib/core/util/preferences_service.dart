import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// ISP: callers depend only on this interface.
/// All mutating methods return Future<void> so errors can be awaited/propagated.
abstract class PreferencesService {
  Future<void> saveString(String key, String value);
  Future<void> saveBoolean(String key, bool value);
  Future<void> saveInt(String key, int value);
  Future<void> saveDouble(String key, double value);
  Future<void> saveMap(String key, Map<String, dynamic> data);
  Future<void> remove(String key);
  Future<String?> getString(String key);
  Future<bool?> getBoolean(String key);
  Future<int?> getInt(String key);
  Future<double?> getDouble(String key);
  Future<Map<String, dynamic>?> getMap(String key);
  Future<void> clearAll();
}

class PreferencesServiceImpl implements PreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> saveString(String key, String value) async {
    var prefs = await _prefs;
    await prefs.setString(key, value);
  }

  @override
  Future<void> saveBoolean(String key, bool value) async {
    var prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  @override
  Future<void> saveInt(String key, int value) async {
    var prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    var prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  @override
  Future<void> saveMap(String key, Map<String, dynamic> data) async {
    var prefs = await _prefs;
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  @override
  Future<void> remove(String key) async {
    var prefs = await _prefs;
    await prefs.remove(key);
  }

  @override
  Future<String?> getString(String key) async {
    var prefs = await _prefs;
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    } else {
      return null;
    }
  }

  @override
  Future<bool?> getBoolean(String key) async {
    var prefs = await _prefs;
    if (prefs.containsKey(key)) {
      return prefs.getBool(key);
    } else {
      return null;
    }
  }

  @override
  Future<int?> getInt(String key) async {
    var prefs = await _prefs;
    if (prefs.containsKey(key)) {
      return prefs.getInt(key);
    } else {
      return null;
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    var prefs = await _prefs;
    if (prefs.containsKey(key)) {
      return prefs.getDouble(key);
    } else {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getMap(String key) async {
    var prefs = await _prefs;
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  @override
  Future<void> clearAll() async {
    var prefs = await _prefs;
    await prefs.clear();
  }
}
