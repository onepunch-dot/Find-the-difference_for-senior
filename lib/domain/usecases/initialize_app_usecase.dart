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
  /// 1. Supabase 연결 확인
  /// 2. 테마 데이터 로드 확인 (온라인 시)
  Future<InitializeResult> execute() async {
    try {
      // 1. Supabase 초기화 확인
      if (!SupabaseClientManager.isInitialized) {
        // Supabase 초기화 실패 (오프라인 또는 네트워크 에러)
        // 오프라인 모드로 계속 진행
        return InitializeResult.success();
      }

      // 2. 인증 확인 (skipAuth가 false일 때만)
      if (!skipAuth && !SupabaseClientManager.isAuthenticated) {
        // 익명 로그인이 되어있지 않으면 에러
        return InitializeResult.failure('인증에 실패했습니다.');
      }

      // 3. 테마 데이터 로드 확인 (최소 1개 이상)
      try {
        final themes = await _themeRepository.getAllThemes();
        if (themes.isEmpty) {
          // 테마가 없으면 오프라인 모드로 진행
          return InitializeResult.success();
        }
      } catch (e) {
        // 테마 로드 실패해도 오프라인 모드로 진행
        return InitializeResult.success();
      }

      return InitializeResult.success();
    } catch (e) {
      // 기타 에러가 발생해도 앱은 계속 실행
      return InitializeResult.success();
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
