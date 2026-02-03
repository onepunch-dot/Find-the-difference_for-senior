import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 파일 버전 및 메타데이터 관리
class FileStore {
  static const String _imageVersionPrefix = 'image_version_';
  static const String _audioVersionPrefix = 'audio_version_';

  /// 이미지 버전 저장
  Future<void> saveImageVersion(String key, int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_imageVersionPrefix$key', version);
  }

  /// 이미지 버전 조회
  Future<int?> getImageVersion(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_imageVersionPrefix$key');
  }

  /// 오디오 버전 저장
  Future<void> saveAudioVersion(String key, int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_audioVersionPrefix$key', version);
  }

  /// 오디오 버전 조회
  Future<int?> getAudioVersion(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_audioVersionPrefix$key');
  }

  /// 이미지 버전이 다른지 확인 (캐시 무효화 필요 여부)
  Future<bool> isImageVersionDifferent(String key, int serverVersion) async {
    final localVersion = await getImageVersion(key);
    return localVersion == null || localVersion != serverVersion;
  }

  /// 오디오 버전이 다른지 확인 (캐시 무효화 필요 여부)
  Future<bool> isAudioVersionDifferent(String key, int serverVersion) async {
    final localVersion = await getAudioVersion(key);
    return localVersion == null || localVersion != serverVersion;
  }

  /// 완료한 스테이지 ID 목록 저장 (로컬 캐시)
  Future<void> saveCompletedStages(List<String> stageIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('completed_stages', jsonEncode(stageIds));
  }

  /// 완료한 스테이지 ID 목록 조회 (로컬 캐시)
  Future<List<String>> getCompletedStages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('completed_stages');
    if (data == null) return [];

    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => e as String).toList();
  }

  /// 스테이지 완료 추가 (로컬)
  Future<void> addCompletedStage(String stageId) async {
    final completed = await getCompletedStages();
    if (!completed.contains(stageId)) {
      completed.add(stageId);
      await saveCompletedStages(completed);
    }
  }

  /// 모든 설정 및 캐시 메타데이터 삭제
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
