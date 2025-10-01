import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farms/core/i18n/language_controller.dart';

void main() {
  group('LanguageController Tests', () {
    late LanguageController controller;

    setUp(() {
      controller = LanguageController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Default locale is English', () {
      expect(controller.locale, const Locale('en'));
    });

    test('Change language updates locale', () {
      controller.changeLanguage('es');
      expect(controller.locale, const Locale('es'));

      controller.changeLanguage('pt');
      expect(controller.locale, const Locale('pt'));

      controller.changeLanguage('zh');
      expect(controller.locale, const Locale('zh'));
    });

    test('Change language notifies listeners', () {
      var notificationCount = 0;
      controller.addListener(() {
        notificationCount++;
      });

      controller.changeLanguage('es');
      expect(notificationCount, 1);

      controller.changeLanguage('pt');
      expect(notificationCount, 2);
    });

    test('Supported language codes are correct', () {
      expect(LanguageController.supportedLanguageCodes, ['en', 'es', 'pt', 'zh']);
    });

    test('isSupported returns true for supported languages', () {
      expect(LanguageController.isSupported('en'), true);
      expect(LanguageController.isSupported('es'), true);
      expect(LanguageController.isSupported('pt'), true);
      expect(LanguageController.isSupported('zh'), true);
    });

    test('isSupported returns false for unsupported languages', () {
      expect(LanguageController.isSupported('fr'), false);
      expect(LanguageController.isSupported('de'), false);
      expect(LanguageController.isSupported('ja'), false);
    });
  });
}
