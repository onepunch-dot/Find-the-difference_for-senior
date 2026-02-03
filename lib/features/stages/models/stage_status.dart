import '../../../domain/models/stage.dart';

/// 스테이지 상태
enum StageStatus {
  completed, // 완료됨
  available, // 플레이 가능
  locked, // 잠김 (순차 진행 시)
}

/// 스테이지 + 상태 조합 모델
class StageWithStatus {
  final Stage stage;
  final StageStatus status;

  const StageWithStatus({
    required this.stage,
    required this.status,
  });

  /// 플레이 가능 여부
  bool get isPlayable => status == StageStatus.available || status == StageStatus.completed;

  /// 완료 여부
  bool get isCompleted => status == StageStatus.completed;

  /// 잠김 여부
  bool get isLocked => status == StageStatus.locked;
}
