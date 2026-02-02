import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_service.dart';
import 'supabase_service.dart';

class AudioService {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final CacheService _cacheService = CacheService();
  final SupabaseService _supabaseService = SupabaseService();

  bool _bgmEnabled = true;
  bool _sfxEnabled = true;
  String? _currentBgmTheme;

  // 싱글톤 패턴
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _loadSettings();
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// 설정 로드
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _bgmEnabled = prefs.getBool('bgm_enabled') ?? true;
    _sfxEnabled = prefs.getBool('sfx_enabled') ?? true;
  }

  /// BGM 설정 저장
  Future<void> setBgmEnabled(bool enabled) async {
    _bgmEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bgm_enabled', enabled);

    if (!enabled) {
      await _bgmPlayer.stop();
    } else if (_currentBgmTheme != null) {
      // 현재 테마의 BGM 재생
      await playThemeBgm(_currentBgmTheme!, bgmPath: '', version: 1);
    }
  }

  /// 효과음 설정 저장
  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sfx_enabled', enabled);
  }

  bool get isBgmEnabled => _bgmEnabled;
  bool get isSfxEnabled => _sfxEnabled;

  /// 테마 BGM 재생
  Future<void> playThemeBgm(
    String themeName, {
    required String bgmPath,
    required int version,
  }) async {
    if (!_bgmEnabled || bgmPath.isEmpty) return;

    _currentBgmTheme = themeName;

    try {
      // BGM 캐싱
      final cacheKey = 'bgm_$themeName.mp3';
      final url = _supabaseService.getBgmUrl(bgmPath);
      final cachedFile = await _cacheService.cacheBgm(url, cacheKey, version);

      // BGM 재생
      await _bgmPlayer.stop();
      await _bgmPlayer.play(DeviceFileSource(cachedFile.path));
    } catch (e) {
      print('BGM 재생 오류: $e');
    }
  }

  /// BGM 정지
  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
    _currentBgmTheme = null;
  }

  /// BGM 일시정지
  Future<void> pauseBgm() async {
    await _bgmPlayer.pause();
  }

  /// BGM 재개
  Future<void> resumeBgm() async {
    if (_bgmEnabled) {
      await _bgmPlayer.resume();
    }
  }

  /// 정답 효과음
  Future<void> playCorrectSound() async {
    if (!_sfxEnabled) return;
    // TODO: 실제 효과음 파일로 교체
    // await _sfxPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  /// 오답 효과음
  Future<void> playWrongSound() async {
    if (!_sfxEnabled) return;
    // TODO: 실제 효과음 파일로 교체
    // await _sfxPlayer.play(AssetSource('sounds/wrong.mp3'));
  }

  /// 클리어 효과음
  Future<void> playClearSound() async {
    if (!_sfxEnabled) return;
    // TODO: 실제 효과음 파일로 교체
    // await _sfxPlayer.play(AssetSource('sounds/clear.mp3'));
  }

  /// 모든 오디오 정지
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
