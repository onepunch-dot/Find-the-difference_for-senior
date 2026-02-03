import '../models/theme.dart';
import '../repositories/theme_repository.dart';

/// 테마 목록 조회 UseCase
class GetThemesUseCase {
  final ThemeRepository _repository;

  GetThemesUseCase(this._repository);

  /// 모든 테마 조회 (정렬 순서대로)
  Future<List<Theme>> execute() async {
    return await _repository.getAllThemes();
  }
}

/// 사용자가 구매한 테마 ID 목록 조회 UseCase
class GetPurchasedThemeIdsUseCase {
  final ThemeRepository _repository;

  GetPurchasedThemeIdsUseCase(this._repository);

  /// 구매한 테마 ID 목록 조회
  Future<List<String>> execute(String userId) async {
    return await _repository.getPurchasedThemeIds(userId);
  }
}
