import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_themes_usecase.dart';
import '../../data/supabase/supabase_client.dart';
import 'models/theme_status.dart';

/// HomePage 상태 관리
class HomeViewModel extends ChangeNotifier {
  final GetThemesUseCase _getThemesUseCase;
  final GetPurchasedThemeIdsUseCase _getPurchasedThemeIdsUseCase;

  HomeViewModel({
    required GetThemesUseCase getThemesUseCase,
    required GetPurchasedThemeIdsUseCase getPurchasedThemeIdsUseCase,
  })  : _getThemesUseCase = getThemesUseCase,
        _getPurchasedThemeIdsUseCase = getPurchasedThemeIdsUseCase;

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

      // 3. 테마 상태 결정
      _themes = allThemes.map((theme) {
        ThemeStatus status;
        if (theme.isFree) {
          status = ThemeStatus.free;
        } else if (purchasedIds.contains(theme.id)) {
          status = ThemeStatus.purchased;
        } else {
          status = ThemeStatus.locked;
        }

        return ThemeWithStatus(theme: theme, status: status);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '테마 목록을 불러올 수 없습니다: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 테마 선택 (탭)
  void onThemeTap(ThemeWithStatus themeWithStatus) {
    if (themeWithStatus.isPlayable) {
      // 플레이 가능: StageListPage로 이동 (추후 구현)
      debugPrint('Navigate to StageList: ${themeWithStatus.theme.id}');
    } else if (themeWithStatus.needsPurchase) {
      // 구매 필요: 구매 모달 표시
      debugPrint('Show purchase modal: ${themeWithStatus.theme.id}');
    }
  }
}
