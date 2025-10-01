// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Gerenciador de Fazenda';

  @override
  String get homePageTitle => '7777777 Início do Gerenciador de Fazenda';

  @override
  String get counterMessage =>
      'Você pressionou o botão esta quantidade de vezes:';

  @override
  String get incrementTooltip => 'Incrementar';

  @override
  String welcome(String name) {
    return 'Bem-vindo, $name!';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
      zero: 'Nenhum item',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get languageSettings => 'Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get portuguese => 'Português';

  @override
  String get mandarin => 'Chinês Mandarim';
}
