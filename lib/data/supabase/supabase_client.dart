import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_config.dart';

/// Supabase 클라이언트 싱글톤
class SupabaseClientManager {
  static SupabaseClient? _instance;
  static bool _initialized = false;
  static bool _initializationFailed = false;

  /// Supabase 초기화
  static Future<void> initialize() async {
    if (_initialized || _initializationFailed) return;

    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      _instance = Supabase.instance.client;
      _initialized = true;
      debugPrint('Supabase initialized successfully');

      // 익명 로그인 시도 (프로젝트에서 활성화된 경우에만)
      try {
        if (_instance!.auth.currentUser == null) {
          await _instance!.auth.signInAnonymously();
          debugPrint('Signed in anonymously: ${_instance!.auth.currentUser?.id}');
        }
      } catch (authError) {
        // 익명 로그인 비활성화된 경우 무시하고 계속 진행
        debugPrint('Anonymous sign-in not available: $authError');
        // Supabase는 초기화되었지만 인증 없이 사용
      }
    } catch (e) {
      _initializationFailed = true;
      debugPrint('Supabase initialization failed: $e');
      // 앱이 크래시되지 않도록 에러를 무시
      // 오프라인 모드로 계속 실행
    }
  }

  /// Supabase 클라이언트 인스턴스
  static SupabaseClient get instance {
    if (_instance == null) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// Supabase가 정상적으로 초기화되었는지 확인
  static bool get isInitialized => _initialized && _instance != null;

  /// 현재 사용자 ID (익명 사용자 포함)
  /// 인증되지 않은 경우 로컬 디바이스 ID 사용
  static String? get currentUserId {
    if (!isInitialized) return null;

    // Supabase 인증 사용자가 있으면 반환
    final userId = instance.auth.currentUser?.id;
    if (userId != null) return userId;

    // 인증 없이 사용하는 경우 로컬 디바이스 ID 반환
    // TODO: SharedPreferences에서 디바이스 ID 로드/저장
    return 'local_user_001'; // 임시 로컬 사용자 ID
  }

  /// 현재 사용자가 로그인되어 있는지 확인
  static bool get isAuthenticated => instance.auth.currentUser != null;
}
