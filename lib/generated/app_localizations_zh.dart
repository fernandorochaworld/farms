// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '农场管理器';

  @override
  String get homePageTitle => '农场管理器主页';

  @override
  String get counterMessage => '您已按下按钮的次数：';

  @override
  String get incrementTooltip => '增加';

  @override
  String welcome(String name) {
    return '欢迎，$name！';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个项目',
      one: '1个项目',
      zero: '没有项目',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get languageSettings => '语言';

  @override
  String get english => '英语';

  @override
  String get spanish => '西班牙语';

  @override
  String get portuguese => '葡萄牙语';

  @override
  String get mandarin => '普通话';

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

  @override
  String get peopleListTitle => 'People';

  @override
  String get personDetailsTitle => 'Person Details';

  @override
  String get personAddTitle => 'Add Person';

  @override
  String get personEditTitle => 'Edit Person';

  @override
  String get personNameLabel => 'Person Name';

  @override
  String get personDescriptionLabel => 'Description';

  @override
  String get personTypeLabel => 'Person Type';

  @override
  String get personAdminLabel => 'Admin Privileges';

  @override
  String get personAdminDescription =>
      'Grant admin access to manage farm settings';

  @override
  String get personTypeOwner => 'Owner';

  @override
  String get personTypeManager => 'Manager';

  @override
  String get personTypeWorker => 'Worker';

  @override
  String get personTypeArrendatario => 'Arrendatario';

  @override
  String get personAddButton => 'Add Person';

  @override
  String get personUpdateButton => 'Update Person';

  @override
  String get personRemoveButton => 'Remove';

  @override
  String get personRemoveConfirmTitle => 'Remove Person';

  @override
  String get personRemoveConfirmMessage =>
      'Are you sure you want to remove this person from the farm?';

  @override
  String get personEmptyStateMessage => 'No people found';

  @override
  String get personSearchHint => 'Search people...';

  @override
  String get personNameRequired => 'Name is required';

  @override
  String get personNameMinLength => 'Name must be at least 3 characters';

  @override
  String get personNameMaxLength => 'Name must not exceed 100 characters';

  @override
  String get personAddedSuccess => 'Person added successfully';

  @override
  String get personUpdatedSuccess => 'Person updated successfully';

  @override
  String get personRemovedSuccess => 'Person removed successfully';

  @override
  String get personAlreadyMember => 'User is already a member of this farm';

  @override
  String get personLastOwnerError => 'Cannot remove the last owner';

  @override
  String get personPermissionDenied =>
      'You do not have permission to perform this action';
}
