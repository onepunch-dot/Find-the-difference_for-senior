import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 힌트 서비스 (무료 힌트 + 리워드 광고)
class HintService extends ChangeNotifier {
  static const String _keyFreeHintsCount = 'free_hints_count';
  static const String _keyLastResetDate = 'last_reset_date';
  static const int maxFreeHints = 2; // 일일 무료 힌트 개수

  int _freeHintsRemaining = maxFreeHints;
  DateTime _lastResetDate = DateTime.now();

  int get freeHintsRemaining => _freeHintsRemaining;
  bool get hasFreeHints => _freeHintsRemaining > 0;

  /// 초기화 (앱 시작 시 호출)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // 마지막 리셋 날짜 가져오기
    final lastResetString = prefs.getString(_keyLastResetDate);
    if (lastResetString != null) {
      _lastResetDate = DateTime.parse(lastResetString);
    }

    // 날짜가 바뀌었으면 리셋
    final now = DateTime.now();
    if (_shouldReset(now)) {
      _freeHintsRemaining = maxFreeHints;
      _lastResetDate = now;
      await _save();
    } else {
      // 저장된 힌트 개수 불러오기
      _freeHintsRemaining = prefs.getInt(_keyFreeHintsCount) ?? maxFreeHints;
    }

    notifyListeners();
  }

  /// 날짜가 바뀌었는지 확인
  bool _shouldReset(DateTime now) {
    return now.year != _lastResetDate.year ||
        now.month != _lastResetDate.month ||
        now.day != _lastResetDate.day;
  }

  /// 무료 힌트 사용
  Future<bool> useFreeHint() async {
    if (!hasFreeHints) return false;

    _freeHintsRemaining--;
    await _save();
    notifyListeners();
    return true;
  }

  /// 리워드 광고 시청 후 힌트 획득
  Future<void> addHintFromAd() async {
    _freeHintsRemaining++;
    await _save();
    notifyListeners();
  }

  /// 저장
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFreeHintsCount, _freeHintsRemaining);
    await prefs.setString(_keyLastResetDate, _lastResetDate.toIso8601String());
  }

  /// 리셋 시간까지 남은 시간 (테스트용)
  Duration getTimeUntilReset() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }
}
