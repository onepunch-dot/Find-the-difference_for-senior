import '../models/theme.dart';

/// 테마 Repository 인터페이스
abstract class ThemeRepository {
  /// 모든 테마 목록 조회 (정렬 순서대로)
  Future<List<Theme>> getAllThemes();

  /// 특정 테마 조회
  Future<Theme?> getThemeById(String id);

  /// 사용자가 구매한 테마 ID 목록 조회
  Future<List<String>> getPurchasedThemeIds(String userId);
}
