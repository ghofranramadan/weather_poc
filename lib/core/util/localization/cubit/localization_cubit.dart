import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization_cache_helper.dart';
import '../../preferences_service.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  final LocalizationCacheHelper _cacheHelper;

  LocalizationCubit()
    : _cacheHelper = LocalizationCacheHelper(PreferencesServiceImpl()),
      super(LocalizationInitial());

  Future<void> getSavedLanguage() async {
    final languageCode = await _cacheHelper.getLanguageCode();
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }

  Future<void> changeLanguage(String languageCode) async {
    await _cacheHelper.setLanguageCode(languageCode);
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }
}

