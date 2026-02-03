import '../models/purchase.dart';

/// 구매 Repository 인터페이스
abstract class PurchaseRepository {
  /// 사용자의 모든 구매 내역 조회
  Future<List<Purchase>> getUserPurchases(String userId);

  /// 구매 기록 추가
  Future<void> addPurchase(Purchase purchase);

  /// 광고 제거 구매 여부 확인
  Future<bool> hasAdRemovalPurchase(String userId);

  /// 특정 테마 구매 여부 확인
  Future<bool> hasThemePurchase(String userId, String themeId);
}
