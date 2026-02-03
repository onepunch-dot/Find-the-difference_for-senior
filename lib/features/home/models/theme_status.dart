import '../../../domain/models/theme.dart';

/// 테마 상태
enum ThemeStatus {
  free, // 무료 (즉시 플레이 가능)
  purchased, // 구매됨 (플레이 가능)
  locked, // 잠김 (구매 필요)
}

/// 테마 + 상태 조합 모델
class ThemeWithStatus {
  final Theme theme;
  final ThemeStatus status;

  const ThemeWithStatus({
    required this.theme,
    required this.status,
  });

  /// 플레이 가능 여부
  bool get isPlayable => status == ThemeStatus.free || status == ThemeStatus.purchased;

  /// 구매 필요 여부
  bool get needsPurchase => status == ThemeStatus.locked;
}
