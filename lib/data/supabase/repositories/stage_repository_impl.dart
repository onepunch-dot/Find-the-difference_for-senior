import '../../../domain/models/stage.dart';
import '../../../domain/repositories/stage_repository.dart';
import '../supabase_client.dart';
import '../dto/stage_dto.dart';

class StageRepositoryImpl implements StageRepository {
  final _client = SupabaseClientManager.instance;

  @override
  Future<List<Stage>> getStagesByThemeId(String themeId) async {
    try {
      final response = await _client
          .from('stages')
          .select()
          .eq('theme_id', themeId)
          .order('stage_number', ascending: true);

      return (response as List)
          .map((json) => StageDto.fromJson(json).toDomain())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch stages: $e');
    }
  }

  @override
  Future<Stage?> getStageById(String id) async {
    try {
      final response = await _client
          .from('stages')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return StageDto.fromJson(response).toDomain();
    } catch (e) {
      throw Exception('Failed to fetch stage: $e');
    }
  }

  @override
  Future<List<String>> getCompletedStageIds(String userId) async {
    try {
      final response = await _client
          .from('completions')
          .select('stage_id')
          .eq('user_id', userId);

      return (response as List)
          .map((json) => json['stage_id'] as String)
          .toList();
    } catch (e) {
      // 에러 발생 시 빈 목록 반환 (오프라인 등)
      return [];
    }
  }

  @override
  Future<void> markStageAsCompleted(String userId, String stageId) async {
    try {
      await _client.from('completions').insert({
        'user_id': userId,
        'stage_id': stageId,
      });
    } catch (e) {
      // 이미 완료 기록이 있는 경우 무시 (UNIQUE constraint)
      // 에러가 발생해도 앱이 깨지지 않도록 처리
    }
  }
}
