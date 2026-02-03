/// Supabase 설정
/// 실제 사용 시 환경변수나 별도 파일로 관리 권장
class SupabaseConfig {
  // TODO: 실제 Supabase 프로젝트 URL과 anon key로 교체 필요
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // Storage 버킷 이름
  static const String stageImagesBucket = 'stage-images';
  static const String themeAudioBucket = 'theme-audio';
}
