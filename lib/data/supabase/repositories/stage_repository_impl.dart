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
          .from('user_progress')
          .select('stage_id')
          .eq('user_id', userId)
          .eq('completed', true);

      return (response as List)
          .map((json) => json['stage_id'] as String)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch completed stages: $e');
    }
  }

  @override
  Future<void> markStageAsCompleted(String userId, String stageId) async {
    try {
      await _client.from('user_progress').upsert({
        'user_id': userId,
        'stage_id': stageId,
        'completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to mark stage as completed: $e');
    }
  }
}
