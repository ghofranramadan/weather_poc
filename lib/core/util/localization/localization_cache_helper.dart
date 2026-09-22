import '../preferences_service.dart';

class LocalizationCacheHelper {
  final PreferencesService _preferencesService;

  LocalizationCacheHelper(this._preferencesService);

  Future<String> getLanguageCode() async {
    return await _preferencesService.getString('lang') ?? 'en';
  }

  Future<void> setLanguageCode(String languageCode) async {
    await _preferencesService.saveString('lang', languageCode);
  }
}

