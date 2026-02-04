import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_themes_usecase.dart';
import '../../domain/repositories/stage_repository.dart';
import '../../data/supabase/supabase_client.dart';
import '../../core/utils/connectivity_service.dart';
import 'models/theme_status.dart';

/// HomePage 상태 관리
class HomeViewModel extends ChangeNotifier {
  final GetThemesUseCase _getThemesUseCase;
  final GetPurchasedThemeIdsUseCase _getPurchasedThemeIdsUseCase;
  final StageRepository _stageRepository;

  HomeViewModel({
    required GetThemesUseCase getThemesUseCase,
    required GetPurchasedThemeIdsUseCase getPurchasedThemeIdsUseCase,
    required StageRepository stageRepository,
  })  : _getThemesUseCase = getThemesUseCase,
        _getPurchasedThemeIdsUseCase = getPurchasedThemeIdsUseCase,
        _stageRepository = stageRepository;

  // 상태
  List<ThemeWithStatus> _themes = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ThemeWithStatus> get themes => _themes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// 테마 목록 로드
  Future<void> loadThemes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. 모든 테마 조회
      final allThemes = await _getThemesUseCase.execute();

      // 2. 구매한 테마 ID 목록 조회
      final userId = SupabaseClientManager.currentUserId;
      final purchasedIds = userId != null
          ? await _getPurchasedThemeIdsUseCase.execute(userId)
          : <String>[];

      // 3. 완료한 스테이지 ID 목록 조회
      final completedStageIds = userId != null
          ? await _stageRepository.getCompletedStageIds(userId)
          : <String>[];

      // 4. 테마 상태 및 진행률 결정
      final themesWithProgress = await Future.wait(
        allThemes.map((theme) async {
          // 상태 결정
          ThemeStatus status;
          if (theme.isFree) {
            status = ThemeStatus.free;
          } else if (purchasedIds.contains(theme.id)) {
            status = ThemeStatus.purchased;
          } else {
            status = ThemeStatus.locked;
          }

          // 진행률 계산
          try {
            final stages = await _stageRepository.getStagesByThemeId(theme.id);
            final completed = stages
                .where((stage) => completedStageIds.contains(stage.id))
                .length;

            return ThemeWithStatus(
              theme: theme,
              status: status,
              completedStages: completed,
              totalStages: stages.length,
            );
          } catch (e) {
            // 진행률 조회 실패 시 기본값
            return ThemeWithStatus(
              theme: theme,
              status: status,
              completedStages: 0,
              totalStages: 0,
            );
          }
        }),
      );

      _themes = themesWithProgress;
      _isLoading = false;

      // 네트워크 상태 업데이트
      ConnectivityService().setOnline(true);

      notifyListeners();
    } catch (e) {
      _errorMessage = '테마 목록을 불러올 수 없습니다: $e';
      _isLoading = false;

      // 네트워크 오류 시 오프라인으로 간주
      if (e.toString().contains('Failed to fetch') ||
          e.toString().contains('Network')) {
        ConnectivityService().setOnline(false);
        _errorMessage = '${ConnectivityService.offlineMessage}\n캐시된 콘텐츠만 사용 가능합니다.';
      }

      notifyListeners();
    }
  }

  /// 테마 선택 (탭) - 반환값은 네비게이션 또는 구매 정보
  ThemeWithStatus? onThemeTap(ThemeWithStatus themeWithStatus) {
    if (themeWithStatus.isPlayable) {
      // 플레이 가능: StageListPage로 이동
      return themeWithStatus;
    } else if (themeWithStatus.needsPurchase) {
      // 구매 필요: 구매 모달 표시 신호 (Page에서 처리)
      return null;
    }
    return null;
  }

  /// 테마 구매 처리
  Future<bool> purchaseTheme(String themeId) async {
    // TODO: 실제 IAP 연동
    // 현재는 즉시 성공 반환
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // 구매 성공 후 테마 목록 갱신
      await loadThemes();
      return true;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    }
  }
}
