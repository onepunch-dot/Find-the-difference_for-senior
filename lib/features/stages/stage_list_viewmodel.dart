import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_stages_usecase.dart';
import '../../data/supabase/supabase_client.dart';
import 'models/stage_status.dart';

/// StageListPage 상태 관리
class StageListViewModel extends ChangeNotifier {
  final GetStagesUseCase _getStagesUseCase;
  final GetCompletedStageIdsUseCase _getCompletedStageIdsUseCase;
  final String themeId;

  StageListViewModel({
    required GetStagesUseCase getStagesUseCase,
    required GetCompletedStageIdsUseCase getCompletedStageIdsUseCase,
    required this.themeId,
  })  : _getStagesUseCase = getStagesUseCase,
        _getCompletedStageIdsUseCase = getCompletedStageIdsUseCase;

  // 상태
  List<StageWithStatus> _stages = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<StageWithStatus> get stages => _stages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// 스테이지 목록 로드
  Future<void> loadStages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. 테마의 모든 스테이지 조회
      final allStages = await _getStagesUseCase.execute(themeId);

      // 2. 완료한 스테이지 ID 목록 조회
      final userId = SupabaseClientManager.currentUserId;
      final completedIds = userId != null
          ? await _getCompletedStageIdsUseCase.execute(userId)
          : <String>[];

      // 3. 스테이지 상태 결정
      _stages = allStages.map((stage) {
        StageStatus status;
        if (completedIds.contains(stage.id)) {
          status = StageStatus.completed;
        } else {
          // 순차 진행: 이전 스테이지가 완료되지 않으면 잠김
          final previousStageNumber = stage.stageNumber - 1;
          if (previousStageNumber > 0) {
            final previousStage = allStages.firstWhere(
              (s) => s.stageNumber == previousStageNumber,
              orElse: () => stage,
            );
            final isPreviousCompleted = completedIds.contains(previousStage.id);
            status = isPreviousCompleted ? StageStatus.available : StageStatus.locked;
          } else {
            // 첫 번째 스테이지는 항상 플레이 가능
            status = StageStatus.available;
          }
        }

        return StageWithStatus(stage: stage, status: status);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '스테이지 목록을 불러올 수 없습니다: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 스테이지 선택 (탭)
  void onStageTap(StageWithStatus stageWithStatus) {
    if (stageWithStatus.isPlayable) {
      // 플레이 가능: StagePage로 이동 (추후 구현)
      debugPrint('Navigate to Stage: ${stageWithStatus.stage.id}');
    } else if (stageWithStatus.isLocked) {
      // 잠김: 안내 메시지
      debugPrint('Stage is locked: ${stageWithStatus.stage.id}');
    }
  }
}
