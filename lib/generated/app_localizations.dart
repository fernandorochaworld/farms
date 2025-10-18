import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Farm Manager'**
  String get appTitle;

  /// The home page title
  ///
  /// In en, this message translates to:
  /// **'Farm Manager Home'**
  String get homePageTitle;

  /// Message shown above the counter
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get counterMessage;

  /// Tooltip for the increment button
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementTooltip;

  /// Welcome message with user name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcome(String name);

  /// Number of items with plural support
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Portuguese language option
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// Mandarin Chinese language option
  ///
  /// In en, this message translates to:
  /// **'Mandarin Chinese'**
  String get mandarin;

  /// Title for create farm screen
  ///
  /// In en, this message translates to:
  /// **'Create Farm'**
  String get farmCreateTitle;

  /// Title for edit farm screen
  ///
  /// In en, this message translates to:
  /// **'Edit Farm'**
  String get farmEditTitle;

  /// Title for farm list screen
  ///
  /// In en, this message translates to:
  /// **'My Farms'**
  String get farmListTitle;

  /// Title for farm details screen
  ///
  /// In en, this message translates to:
  /// **'Farm Details'**
  String get farmDetailsTitle;

  /// Title for dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Label for farm name field
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmNameLabel;

  /// Label for farm description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get farmDescriptionLabel;

  /// Label for farm capacity field
  ///
  /// In en, this message translates to:
  /// **'Capacity (head)'**
  String get farmCapacityLabel;

  /// Button text for creating a farm
  ///
  /// In en, this message translates to:
  /// **'Create Farm'**
  String get farmCreateButton;

  /// Button text for updating a farm
  ///
  /// In en, this message translates to:
  /// **'Update Farm'**
  String get farmUpdateButton;

  /// Button text for deleting a farm
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get farmDeleteButton;

  /// Confirmation message for deleting a farm
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this farm?'**
  String get farmDeleteConfirmMessage;

  /// Message shown when user has no farms
  ///
  /// In en, this message translates to:
  /// **'No farms found. Create your first farm to get started!'**
  String get farmEmptyStateMessage;

  /// Welcome message on dashboard
  ///
  /// In en, this message translates to:
  /// **'Welcome to your farm dashboard'**
  String get dashboardWelcomeMessage;

  /// Validation error for required farm name
  ///
  /// In en, this message translates to:
  /// **'Farm name is required'**
  String get farmNameRequired;

  /// Validation error for farm name minimum length
  ///
  /// In en, this message translates to:
  /// **'Farm name must be at least 3 characters'**
  String get farmNameMinLength;

  /// Validation error for farm name maximum length
  ///
  /// In en, this message translates to:
  /// **'Farm name must not exceed 100 characters'**
  String get farmNameMaxLength;

  /// Validation error for required capacity
  ///
  /// In en, this message translates to:
  /// **'Capacity is required'**
  String get farmCapacityRequired;

  /// Validation error for invalid capacity
  ///
  /// In en, this message translates to:
  /// **'Capacity must be a valid number'**
  String get farmCapacityInvalid;

  /// Validation error for capacity must be positive
  ///
  /// In en, this message translates to:
  /// **'Capacity must be greater than 0'**
  String get farmCapacityPositive;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
