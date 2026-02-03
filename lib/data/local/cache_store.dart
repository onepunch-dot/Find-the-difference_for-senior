import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// 이미지/오디오 파일 캐시 관리
class CacheStore {
  static const String _imageCacheDir = 'images';
  static const String _audioCacheDir = 'audio';

  /// 캐시 디렉토리 경로 가져오기
  Future<Directory> _getCacheDir(String subDir) async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/$subDir');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// 이미지 캐시 경로
  Future<String> getImageCachePath(String key) async {
    final dir = await _getCacheDir(_imageCacheDir);
    return '${dir.path}/$key';
  }

  /// 오디오 캐시 경로
  Future<String> getAudioCachePath(String key) async {
    final dir = await _getCacheDir(_audioCacheDir);
    return '${dir.path}/$key';
  }

  /// 이미지가 캐시에 있는지 확인
  Future<bool> hasImageCache(String key) async {
    final path = await getImageCachePath(key);
    return File(path).exists();
  }

  /// 오디오가 캐시에 있는지 확인
  Future<bool> hasAudioCache(String key) async {
    final path = await getAudioCachePath(key);
    return File(path).exists();
  }

  /// URL에서 이미지 다운로드 및 캐시
  Future<String> downloadAndCacheImage(String url, String key) async {
    final path = await getImageCachePath(key);
    final file = File(path);

    // 이미 캐시되어 있으면 경로 반환
    if (await file.exists()) {
      return path;
    }

    // 다운로드
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    // 저장
    await file.writeAsBytes(response.bodyBytes);
    return path;
  }

  /// URL에서 오디오 다운로드 및 캐시
  Future<String> downloadAndCacheAudio(String url, String key) async {
    final path = await getAudioCachePath(key);
    final file = File(path);

    // 이미 캐시되어 있으면 경로 반환
    if (await file.exists()) {
      return path;
    }

    // 다운로드
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download audio: ${response.statusCode}');
    }

    // 저장
    await file.writeAsBytes(response.bodyBytes);
    return path;
  }

  /// 특정 이미지 캐시 삭제
  Future<void> deleteImageCache(String key) async {
    final path = await getImageCachePath(key);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 특정 오디오 캐시 삭제
  Future<void> deleteAudioCache(String key) async {
    final path = await getAudioCachePath(key);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 모든 이미지 캐시 삭제
  Future<void> clearImageCache() async {
    final dir = await _getCacheDir(_imageCacheDir);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create();
    }
  }

  /// 모든 오디오 캐시 삭제
  Future<void> clearAudioCache() async {
    final dir = await _getCacheDir(_audioCacheDir);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create();
    }
  }

  /// 전체 캐시 삭제
  Future<void> clearAllCache() async {
    await clearImageCache();
    await clearAudioCache();
  }
}
