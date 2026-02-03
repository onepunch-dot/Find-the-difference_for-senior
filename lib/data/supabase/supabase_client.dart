import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_config.dart';

/// Supabase 클라이언트 싱글톤
class SupabaseClientManager {
  static SupabaseClient? _instance;

  /// Supabase 초기화
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    _instance = Supabase.instance.client;
  }

  /// Supabase 클라이언트 인스턴스
  static SupabaseClient get instance {
    if (_instance == null) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// 현재 사용자 ID (익명 사용자 포함)
  static String? get currentUserId => instance.auth.currentUser?.id;

  /// 현재 사용자가 로그인되어 있는지 확인
  static bool get isAuthenticated => currentUserId != null;
}
