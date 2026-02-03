import '../../../domain/models/purchase.dart';
import '../../../domain/repositories/purchase_repository.dart';
import '../supabase_client.dart';
import '../dto/purchase_dto.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final _client = SupabaseClientManager.instance;

  @override
  Future<List<Purchase>> getUserPurchases(String userId) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('user_id', userId)
          .order('purchased_at', ascending: false);

      return (response as List)
          .map((json) => PurchaseDto.fromJson(json).toDomain())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch purchases: $e');
    }
  }

  @override
  Future<void> addPurchase(Purchase purchase) async {
    try {
      final dto = PurchaseDto.fromDomain(purchase);
      await _client.from('purchases').insert(dto.toJson());
    } catch (e) {
      throw Exception('Failed to add purchase: $e');
    }
  }

  @override
  Future<bool> hasAdRemovalPurchase(String userId) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('user_id', userId)
          .eq('type', 'ad_removal')
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check ad removal purchase: $e');
    }
  }

  @override
  Future<bool> hasThemePurchase(String userId, String themeId) async {
    try {
      final response = await _client
          .from('purchases')
          .select()
          .eq('user_id', userId)
          .eq('type', 'theme')
          .eq('theme_id', themeId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check theme purchase: $e');
    }
  }
}
