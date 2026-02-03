import '../repositories/theme_repository.dart';
import '../../data/supabase/supabase_client.dart';

/// 앱 초기화 UseCase
class InitializeAppUseCase {
  final ThemeRepository _themeRepository;
  final bool skipAuth; // 테스트용: 인증 건너뛰기

  InitializeAppUseCase(
    this._themeRepository, {
    this.skipAuth = false,
  });

  /// 앱 초기화 실행
  /// 1. 익명 로그인 (필요 시)
  /// 2. 테마 데이터 로드 확인
  Future<InitializeResult> execute() async {
    try {
      // 1. 익명 로그인 확인 (skipAuth가 false일 때만)
      if (!skipAuth) {
        if (!SupabaseClientManager.isAuthenticated) {
          final response = await SupabaseClientManager.instance.auth.signInAnonymously();
          if (response.user == null) {
            return InitializeResult.failure('익명 로그인에 실패했습니다.');
          }
        }
      }

      // 2. 테마 데이터 로드 확인 (최소 1개 이상)
      final themes = await _themeRepository.getAllThemes();
      if (themes.isEmpty) {
        return InitializeResult.failure('콘텐츠를 불러올 수 없습니다.');
      }

      return InitializeResult.success();
    } catch (e) {
      // 네트워크 에러 또는 기타 에러
      return InitializeResult.failure('초기화 중 오류가 발생했습니다: $e');
    }
  }
}

/// 초기화 결과
class InitializeResult {
  final bool isSuccess;
  final String? errorMessage;

  InitializeResult._({required this.isSuccess, this.errorMessage});

  factory InitializeResult.success() => InitializeResult._(isSuccess: true);
  factory InitializeResult.failure(String message) =>
      InitializeResult._(isSuccess: false, errorMessage: message);
}
