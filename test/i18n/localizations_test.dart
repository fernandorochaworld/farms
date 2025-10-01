import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farms/generated/app_localizations.dart';

void main() {
  group('Localizations Tests', () {
    test('English translations load correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('en'));

      expect(localizations.appTitle, 'Farm Manager');
      expect(localizations.homePageTitle, 'Farm Manager Home');
      expect(localizations.counterMessage, 'You have pushed the button this many times:');
      expect(localizations.incrementTooltip, 'Increment');
      expect(localizations.settingsTitle, 'Settings');
      expect(localizations.languageSettings, 'Language');
      expect(localizations.english, 'English');
      expect(localizations.spanish, 'Spanish');
      expect(localizations.portuguese, 'Portuguese');
      expect(localizations.mandarin, 'Mandarin Chinese');
    });

    test('Spanish translations load correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('es'));

      expect(localizations.appTitle, 'Administrador de Granja');
      expect(localizations.homePageTitle, 'Inicio del Administrador de Granja');
      expect(localizations.counterMessage, 'Has presionado el botón esta cantidad de veces:');
      expect(localizations.incrementTooltip, 'Incrementar');
      expect(localizations.settingsTitle, 'Configuración');
      expect(localizations.languageSettings, 'Idioma');
      expect(localizations.english, 'Inglés');
      expect(localizations.spanish, 'Español');
      expect(localizations.portuguese, 'Portugués');
      expect(localizations.mandarin, 'Chino Mandarín');
    });

    test('Portuguese translations load correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('pt'));

      expect(localizations.appTitle, 'Gerenciador de Fazenda');
      expect(localizations.homePageTitle, 'Início do Gerenciador de Fazenda');
      expect(localizations.counterMessage, 'Você pressionou o botão esta quantidade de vezes:');
      expect(localizations.incrementTooltip, 'Incrementar');
      expect(localizations.settingsTitle, 'Configurações');
      expect(localizations.languageSettings, 'Idioma');
      expect(localizations.english, 'Inglês');
      expect(localizations.spanish, 'Espanhol');
      expect(localizations.portuguese, 'Português');
      expect(localizations.mandarin, 'Chinês Mandarim');
    });

    test('Mandarin translations load correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('zh'));

      expect(localizations.appTitle, '农场管理器');
      expect(localizations.homePageTitle, '农场管理器主页');
      expect(localizations.counterMessage, '您已按下按钮的次数：');
      expect(localizations.incrementTooltip, '增加');
      expect(localizations.settingsTitle, '设置');
      expect(localizations.languageSettings, '语言');
      expect(localizations.english, '英语');
      expect(localizations.spanish, '西班牙语');
      expect(localizations.portuguese, '葡萄牙语');
      expect(localizations.mandarin, '普通话');
    });

    test('Placeholder interpolation works correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('en'));

      expect(localizations.welcome('John'), 'Welcome, John!');
      expect(localizations.welcome('Maria'), 'Welcome, Maria!');
    });

    test('Plural forms work correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('en'));

      expect(localizations.itemCount(0), 'No items');
      expect(localizations.itemCount(1), '1 item');
      expect(localizations.itemCount(5), '5 items');
      expect(localizations.itemCount(100), '100 items');
    });

    test('Spanish plural forms work correctly', () async {
      final localizations = await AppLocalizations.delegate.load(const Locale('es'));

      expect(localizations.itemCount(0), 'Sin elementos');
      expect(localizations.itemCount(1), '1 elemento');
      expect(localizations.itemCount(5), '5 elementos');
    });
  });
}
