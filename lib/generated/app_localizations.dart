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

  /// Title for people list screen
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleListTitle;

  /// Title for person details screen
  ///
  /// In en, this message translates to:
  /// **'Person Details'**
  String get personDetailsTitle;

  /// Title for add person screen
  ///
  /// In en, this message translates to:
  /// **'Add Person'**
  String get personAddTitle;

  /// Title for edit person screen
  ///
  /// In en, this message translates to:
  /// **'Edit Person'**
  String get personEditTitle;

  /// Label for person name field
  ///
  /// In en, this message translates to:
  /// **'Person Name'**
  String get personNameLabel;

  /// Label for person description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get personDescriptionLabel;

  /// Label for person type field
  ///
  /// In en, this message translates to:
  /// **'Person Type'**
  String get personTypeLabel;

  /// Label for admin privileges toggle
  ///
  /// In en, this message translates to:
  /// **'Admin Privileges'**
  String get personAdminLabel;

  /// Description for admin privileges toggle
  ///
  /// In en, this message translates to:
  /// **'Grant admin access to manage farm settings'**
  String get personAdminDescription;

  /// Person type: Owner
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get personTypeOwner;

  /// Person type: Manager
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get personTypeManager;

  /// Person type: Worker
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get personTypeWorker;

  /// Person type: Arrendatario
  ///
  /// In en, this message translates to:
  /// **'Arrendatario'**
  String get personTypeArrendatario;

  /// Button text for adding a person
  ///
  /// In en, this message translates to:
  /// **'Add Person'**
  String get personAddButton;

  /// Button text for updating a person
  ///
  /// In en, this message translates to:
  /// **'Update Person'**
  String get personUpdateButton;

  /// Button text for removing a person
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get personRemoveButton;

  /// Title for remove person confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Remove Person'**
  String get personRemoveConfirmTitle;

  /// Confirmation message for removing a person
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this person from the farm?'**
  String get personRemoveConfirmMessage;

  /// Message shown when no people found
  ///
  /// In en, this message translates to:
  /// **'No people found'**
  String get personEmptyStateMessage;

  /// Hint text for person search field
  ///
  /// In en, this message translates to:
  /// **'Search people...'**
  String get personSearchHint;

  /// Validation error for required person name
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get personNameRequired;

  /// Validation error for person name minimum length
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get personNameMinLength;

  /// Validation error for person name maximum length
  ///
  /// In en, this message translates to:
  /// **'Name must not exceed 100 characters'**
  String get personNameMaxLength;

  /// Success message when person is added
  ///
  /// In en, this message translates to:
  /// **'Person added successfully'**
  String get personAddedSuccess;

  /// Success message when person is updated
  ///
  /// In en, this message translates to:
  /// **'Person updated successfully'**
  String get personUpdatedSuccess;

  /// Success message when person is removed
  ///
  /// In en, this message translates to:
  /// **'Person removed successfully'**
  String get personRemovedSuccess;

  /// Error message when user is already a farm member
  ///
  /// In en, this message translates to:
  /// **'User is already a member of this farm'**
  String get personAlreadyMember;

  /// Error message when trying to remove last owner
  ///
  /// In en, this message translates to:
  /// **'Cannot remove the last owner'**
  String get personLastOwnerError;

  /// Error message for permission denied
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action'**
  String get personPermissionDenied;

  /// No description provided for @lotListTitle.
  ///
  /// In en, this message translates to:
  /// **'Cattle Lots'**
  String get lotListTitle;

  /// No description provided for @lotCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Lot'**
  String get lotCreateTitle;

  /// No description provided for @lotDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lot Details'**
  String get lotDetailsTitle;

  /// No description provided for @lotEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Lot'**
  String get lotEditTitle;

  /// No description provided for @lotNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Lot Name'**
  String get lotNameLabel;

  /// No description provided for @lotCattleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cattle Type'**
  String get lotCattleTypeLabel;

  /// No description provided for @lotGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get lotGenderLabel;

  /// No description provided for @lotBirthDatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Date Range'**
  String get lotBirthDatesLabel;

  /// No description provided for @lotQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial Quantity'**
  String get lotQuantityLabel;

  /// No description provided for @lotStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get lotStatusActive;

  /// No description provided for @lotStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get lotStatusClosed;

  /// No description provided for @cattleTypeBezerro.
  ///
  /// In en, this message translates to:
  /// **'Bezerro'**
  String get cattleTypeBezerro;

  /// No description provided for @cattleTypeNovilho.
  ///
  /// In en, this message translates to:
  /// **'Novilho'**
  String get cattleTypeNovilho;

  /// No description provided for @cattleTypeBoi3Anos.
  ///
  /// In en, this message translates to:
  /// **'Boi 3 anos'**
  String get cattleTypeBoi3Anos;

  /// No description provided for @cattleTypeBoi4Anos.
  ///
  /// In en, this message translates to:
  /// **'Boi 4 anos'**
  String get cattleTypeBoi4Anos;

  /// No description provided for @cattleTypeBoi5MaisAnos.
  ///
  /// In en, this message translates to:
  /// **'Boi 5+ anos'**
  String get cattleTypeBoi5MaisAnos;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get genderMixed;

  /// No description provided for @lotNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Lot name is required'**
  String get lotNameRequired;

  /// No description provided for @lotTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Cattle type is required'**
  String get lotTypeRequired;

  /// No description provided for @lotGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender is required'**
  String get lotGenderRequired;

  /// No description provided for @lotBirthDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Birth dates are required'**
  String get lotBirthDateRequired;

  /// No description provided for @lotQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Initial quantity is required'**
  String get lotQuantityRequired;

  /// No description provided for @lotQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid quantity'**
  String get lotQuantityInvalid;

  /// No description provided for @lotCloseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Lot'**
  String get lotCloseConfirmTitle;

  /// No description provided for @lotCloseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this lot? No new transactions can be added.'**
  String get lotCloseConfirmMessage;

  /// No description provided for @lotReopenConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reopen Lot'**
  String get lotReopenConfirmTitle;

  /// No description provided for @lotReopenConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reopen this lot?'**
  String get lotReopenConfirmMessage;

  /// No description provided for @lotDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Lot'**
  String get lotDeleteConfirmTitle;

  /// No description provided for @lotDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this lot and all its associated data? This action cannot be undone.'**
  String get lotDeleteConfirmMessage;

  /// No description provided for @transactionListTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionListTitle;

  /// No description provided for @transactionCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get transactionCreateTitle;

  /// No description provided for @transactionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetailsTitle;

  /// No description provided for @transactionTypeBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get transactionTypeBuy;

  /// No description provided for @transactionTypeSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get transactionTypeSell;

  /// No description provided for @transactionTypeMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get transactionTypeMove;

  /// No description provided for @transactionTypeDie.
  ///
  /// In en, this message translates to:
  /// **'Record Death'**
  String get transactionTypeDie;

  /// No description provided for @transactionQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get transactionQuantityLabel;

  /// No description provided for @transactionWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Weight'**
  String get transactionWeightLabel;

  /// No description provided for @transactionValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get transactionValueLabel;

  /// No description provided for @transactionDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDateLabel;

  /// No description provided for @weightHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistoryTitle;

  /// No description provided for @addWeightRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Weight Record'**
  String get addWeightRecordTitle;

  /// No description provided for @averageWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Weight'**
  String get averageWeightLabel;

  /// No description provided for @measurementDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement Date'**
  String get measurementDateLabel;

  /// No description provided for @addRecordButton.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecordButton;

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsTitle;

  /// No description provided for @addGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get addGoalTitle;

  /// No description provided for @goalDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get goalDescriptionLabel;

  /// No description provided for @goalWeightTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Weight Target (@)'**
  String get goalWeightTargetLabel;

  /// No description provided for @goalBirthQuantityTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Quantity Target'**
  String get goalBirthQuantityTargetLabel;

  /// No description provided for @goalDefinitionDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Definition Date'**
  String get goalDefinitionDateLabel;

  /// No description provided for @goalDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal Date'**
  String get goalDateLabel;

  /// No description provided for @addGoalButton.
  ///
  /// In en, this message translates to:
  /// **'Add Goal'**
  String get addGoalButton;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @addServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'New Service'**
  String get addServiceTitle;

  /// No description provided for @serviceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceTypeLabel;

  /// No description provided for @serviceDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get serviceDescriptionLabel;

  /// No description provided for @serviceCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get serviceCostLabel;

  /// No description provided for @serviceDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Date'**
  String get serviceDateLabel;

  /// No description provided for @serviceStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get serviceStatusLabel;

  /// No description provided for @addServiceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addServiceButton;
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
