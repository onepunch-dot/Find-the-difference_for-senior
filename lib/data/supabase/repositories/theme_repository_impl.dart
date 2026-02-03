import '../../../domain/models/theme.dart';
import '../../../domain/repositories/theme_repository.dart';
import '../supabase_client.dart';
import '../dto/theme_dto.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final _client = SupabaseClientManager.instance;

  @override
  Future<List<Theme>> getAllThemes() async {
    try {
      final response = await _client
          .from('themes')
          .select()
          .order('order', ascending: true);

      return (response as List)
          .map((json) => ThemeDto.fromJson(json).toDomain())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch themes: $e');
    }
  }

  @override
  Future<Theme?> getThemeById(String id) async {
    try {
      final response = await _client
          .from('themes')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return ThemeDto.fromJson(response).toDomain();
    } catch (e) {
      throw Exception('Failed to fetch theme: $e');
    }
  }

  @override
  Future<List<String>> getPurchasedThemeIds(String userId) async {
    try {
      final response = await _client
          .from('purchases')
          .select('theme_id')
          .eq('user_id', userId)
          .eq('type', 'theme');

      return (response as List)
          .map((json) => json['theme_id'] as String?)
          .whereType<String>()
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch purchased themes: $e');
    }
  }
}
