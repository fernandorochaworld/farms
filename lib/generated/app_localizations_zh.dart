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
}
