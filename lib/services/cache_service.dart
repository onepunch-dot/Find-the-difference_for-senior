import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  // 싱글톤 패턴
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  /// 로컬 캐시 디렉토리 가져오기
  Future<Directory> _getCacheDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// 이미지 캐싱
  Future<File> cacheImage(String url, String cacheKey, int version) async {
    final cacheDir = await _getCacheDir();
    final filePath = '${cacheDir.path}/$cacheKey';
    final file = File(filePath);

    // 버전 확인
    final prefs = await SharedPreferences.getInstance();
    final cachedVersion = prefs.getInt('version_$cacheKey') ?? 0;

    // 캐시가 있고 버전이 같으면 캐시 반환
    if (await file.exists() && cachedVersion == version) {
      return file;
    }

    // 캐시가 없거나 버전이 다르면 다운로드
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        await prefs.setInt('version_$cacheKey', version);
        return file;
      } else {
        throw Exception('이미지 다운로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('이미지 다운로드 오류: $e');
    }
  }

  /// BGM 캐싱
  Future<File> cacheBgm(String url, String cacheKey, int version) async {
    final cacheDir = await _getCacheDir();
    final filePath = '${cacheDir.path}/$cacheKey';
    final file = File(filePath);

    // 버전 확인
    final prefs = await SharedPreferences.getInstance();
    final cachedVersion = prefs.getInt('version_$cacheKey') ?? 0;

    // 캐시가 있고 버전이 같으면 캐시 반환
    if (await file.exists() && cachedVersion == version) {
      return file;
    }

    // 캐시가 없거나 버전이 다르면 다운로드
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        await prefs.setInt('version_$cacheKey', version);
        return file;
      } else {
        throw Exception('BGM 다운로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('BGM 다운로드 오류: $e');
    }
  }

  /// 캐시 파일 존재 확인
  Future<bool> isCached(String cacheKey) async {
    final cacheDir = await _getCacheDir();
    final file = File('${cacheDir.path}/$cacheKey');
    return await file.exists();
  }

  /// 캐시 삭제
  Future<void> clearCache() async {
    final cacheDir = await _getCacheDir();
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 특정 파일 캐시 삭제
  Future<void> deleteCacheFile(String cacheKey) async {
    final cacheDir = await _getCacheDir();
    final file = File('${cacheDir.path}/$cacheKey');
    if (await file.exists()) {
      await file.delete();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('version_$cacheKey');
  }
}
