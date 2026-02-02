import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // 싱글톤 패턴
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  /// 모든 published 테마 가져오기
  Future<List<GameTheme>> fetchThemes() async {
    try {
      final response = await _client
          .from('themes')
          .select()
          .eq('is_published', true)
          .order('order_index', ascending: true);

      return (response as List)
          .map((json) => GameTheme.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('테마 목록을 불러오는데 실패했습니다: $e');
    }
  }

  /// 특정 테마의 스테이지 목록 가져오기
  Future<List<Stage>> fetchStagesByTheme(int themeId) async {
    try {
      final response = await _client
          .from('stages')
          .select()
          .eq('theme_id', themeId)
          .eq('is_published', true)
          .order('order_index', ascending: true);

      return (response as List).map((json) => Stage.fromJson(json)).toList();
    } catch (e) {
      throw Exception('스테이지 목록을 불러오는데 실패했습니다: $e');
    }
  }

  /// 특정 스테이지 가져오기
  Future<Stage> fetchStage(int stageId) async {
    try {
      final response = await _client
          .from('stages')
          .select()
          .eq('id', stageId)
          .single();

      return Stage.fromJson(response);
    } catch (e) {
      throw Exception('스테이지를 불러오는데 실패했습니다: $e');
    }
  }

  /// 이미지 URL 가져오기
  String getImageUrl(String path) {
    return _client.storage.from('stage-images').getPublicUrl(path);
  }

  /// BGM URL 가져오기
  String getBgmUrl(String path) {
    return _client.storage.from('theme-audio').getPublicUrl(path);
  }

  /// 구매 이력 조회
  Future<List<Purchase>> fetchPurchases(String deviceId) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('device_id', deviceId);

      return (response as List).map((json) => Purchase.fromJson(json)).toList();
    } catch (e) {
      throw Exception('구매 이력을 불러오는데 실패했습니다: $e');
    }
  }

  /// 구매 기록 저장
  Future<void> savePurchase({
    required String deviceId,
    required int themeId,
    required String productId,
  }) async {
    try {
      await _client.from('purchases').insert({
        'device_id': deviceId,
        'theme_id': themeId,
        'product_id': productId,
        'purchased_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('구매 기록 저장에 실패했습니다: $e');
    }
  }

  /// 테마가 구매되었는지 확인
  Future<bool> isThemePurchased(String deviceId, int themeId) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('device_id', deviceId)
          .eq('theme_id', themeId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
