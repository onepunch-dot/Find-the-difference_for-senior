import '../models/stage.dart';

/// 스테이지 Repository 인터페이스
abstract class StageRepository {
  /// 특정 테마의 모든 스테이지 조회
  Future<List<Stage>> getStagesByThemeId(String themeId);

  /// 특정 스테이지 조회
  Future<Stage?> getStageById(String id);

  /// 사용자가 완료한 스테이지 ID 목록 조회
  Future<List<String>> getCompletedStageIds(String userId);

  /// 스테이지 완료 기록
  Future<void> markStageAsCompleted(String userId, String stageId);
}
