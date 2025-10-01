// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Administrador de Granja';

  @override
  String get homePageTitle => 'Inicio del Administrador de Granja';

  @override
  String get counterMessage =>
      'Has presionado el botón esta cantidad de veces:';

  @override
  String get incrementTooltip => 'Incrementar';

  @override
  String welcome(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get languageSettings => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get portuguese => 'Portugués';

  @override
  String get mandarin => 'Chino Mandarín';
}
