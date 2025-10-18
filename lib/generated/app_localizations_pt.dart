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
  String get homePageTitle => 'Início do Gerenciador de Fazenda';

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

  @override
  String get farmCreateTitle => 'Create Farm';

  @override
  String get farmEditTitle => 'Edit Farm';

  @override
  String get farmListTitle => 'My Farms';

  @override
  String get farmDetailsTitle => 'Farm Details';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get farmNameLabel => 'Farm Name';

  @override
  String get farmDescriptionLabel => 'Description';

  @override
  String get farmCapacityLabel => 'Capacity (head)';

  @override
  String get farmCreateButton => 'Create Farm';

  @override
  String get farmUpdateButton => 'Update Farm';

  @override
  String get farmDeleteButton => 'Delete';

  @override
  String get farmDeleteConfirmMessage =>
      'Are you sure you want to delete this farm?';

  @override
  String get farmEmptyStateMessage =>
      'No farms found. Create your first farm to get started!';

  @override
  String get dashboardWelcomeMessage => 'Welcome to your farm dashboard';

  @override
  String get farmNameRequired => 'Farm name is required';

  @override
  String get farmNameMinLength => 'Farm name must be at least 3 characters';

  @override
  String get farmNameMaxLength => 'Farm name must not exceed 100 characters';

  @override
  String get farmCapacityRequired => 'Capacity is required';

  @override
  String get farmCapacityInvalid => 'Capacity must be a valid number';

  @override
  String get farmCapacityPositive => 'Capacity must be greater than 0';
}
