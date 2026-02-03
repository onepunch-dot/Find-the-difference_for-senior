import '../models/stage.dart';
import '../repositories/stage_repository.dart';

/// 특정 테마의 스테이지 목록 조회 UseCase
class GetStagesUseCase {
  final StageRepository _repository;

  GetStagesUseCase(this._repository);

  /// 테마 ID로 스테이지 목록 조회
  Future<List<Stage>> execute(String themeId) async {
    return await _repository.getStagesByThemeId(themeId);
  }
}

/// 완료한 스테이지 ID 목록 조회 UseCase
class GetCompletedStageIdsUseCase {
  final StageRepository _repository;

  GetCompletedStageIdsUseCase(this._repository);

  /// 사용자가 완료한 스테이지 ID 목록
  Future<List<String>> execute(String userId) async {
    return await _repository.getCompletedStageIds(userId);
  }
}
