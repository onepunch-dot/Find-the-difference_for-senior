import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BGM 재생 서비스 (싱글톤)
class BGMService {
  static final BGMService _instance = BGMService._internal();
  factory BGMService() => _instance;
  BGMService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isEnabled = true;
  String? _currentBgmUrl;

  /// 초기화
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('music_enabled') ?? true;

    // 루프 설정
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.5);

    debugPrint('BGM Service initialized (enabled: $_isEnabled)');
  }

  /// BGM 활성화 여부
  bool get isEnabled => _isEnabled;

  /// BGM 활성화/비활성화
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', enabled);

    if (!enabled) {
      await stop();
    } else if (_currentBgmUrl != null) {
      await play(_currentBgmUrl!);
    }
  }

  /// BGM 재생
  Future<void> play(String url) async {
    if (!_isEnabled) return;

    // 이미 같은 BGM이 재생 중이면 무시
    if (_currentBgmUrl == url && _player.state == PlayerState.playing) {
      return;
    }

    _currentBgmUrl = url;

    try {
      // URL이 비어있으면 중지
      if (url.isEmpty) {
        await stop();
        return;
      }

      // 웹에서는 네트워크 URL 직접 재생
      if (kIsWeb) {
        await _player.play(UrlSource(url));
      } else {
        // 모바일에서는 캐시된 파일 또는 네트워크 URL 재생
        // TODO: 캐시 서비스 연동
        await _player.play(UrlSource(url));
      }

      debugPrint('BGM playing: $url');
    } catch (e) {
      debugPrint('Failed to play BGM: $e');
    }
  }

  /// BGM 중지
  Future<void> stop() async {
    await _player.stop();
    _currentBgmUrl = null;
    debugPrint('BGM stopped');
  }

  /// BGM 일시정지
  Future<void> pause() async {
    await _player.pause();
    debugPrint('BGM paused');
  }

  /// BGM 재개
  Future<void> resume() async {
    if (!_isEnabled) return;
    await _player.resume();
    debugPrint('BGM resumed');
  }

  /// 볼륨 설정 (0.0 ~ 1.0)
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// 리소스 해제
  Future<void> dispose() async {
    await _player.dispose();
  }
}
