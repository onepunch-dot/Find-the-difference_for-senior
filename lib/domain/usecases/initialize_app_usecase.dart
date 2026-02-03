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
  /// 3. 로컬 모드 지원 (인증 없이도 동작)
  Future<InitializeResult> execute() async {
    try {
      // 1. Supabase 초기화 확인
      if (!SupabaseClientManager.isInitialized) {
        // Supabase 초기화 실패 (오프라인 또는 네트워크 에러)
        // 로컬 모드로 계속 진행
        return InitializeResult.success();
      }

      // 2. 테마 데이터 로드 시도 (온라인인 경우)
      try {
        final themes = await _themeRepository.getAllThemes();
        if (themes.isEmpty) {
          // 테마가 없어도 로컬 모드로 진행 가능
          return InitializeResult.success();
        }
      } catch (e) {
        // 테마 로드 실패해도 로컬 모드로 진행
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
