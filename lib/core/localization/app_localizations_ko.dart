// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '틀린그림찾기';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 시도';

  @override
  String get close => '닫기';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';
}
