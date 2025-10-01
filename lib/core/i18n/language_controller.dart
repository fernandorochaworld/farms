import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Supported language codes
  static const List<String> supportedLanguageCodes = ['en', 'es', 'pt', 'zh'];

  // Check if language code is supported
  static bool isSupported(String languageCode) {
    return supportedLanguageCodes.contains(languageCode);
  }
}
