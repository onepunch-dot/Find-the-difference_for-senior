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
  final int completedStages; // 완료한 스테이지 수
  final int totalStages; // 전체 스테이지 수

  const ThemeWithStatus({
    required this.theme,
    required this.status,
    this.completedStages = 0,
    this.totalStages = 0,
  });

  /// 플레이 가능 여부
  bool get isPlayable => status == ThemeStatus.free || status == ThemeStatus.purchased;

  /// 구매 필요 여부
  bool get needsPurchase => status == ThemeStatus.locked;

  /// 진행률 (0.0 ~ 1.0)
  double get progress => totalStages > 0 ? completedStages / totalStages : 0.0;

  /// 진행률 퍼센티지 (0 ~ 100)
  int get progressPercent => (progress * 100).round();
}
