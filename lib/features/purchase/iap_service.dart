import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// In-App Purchase 서비스
class IAPService {
  static final InAppPurchase _instance = InAppPurchase.instance;
  static bool _initialized = false;

  // 상품 ID (TODO: 실제 상품 ID로 교체)
  static const String adRemovalProductId = 'ad_removal';
  static const String themePackPrefix = 'theme_pack_';

  /// IAP 초기화
  static Future<void> initialize() async {
    if (_initialized) return;

    final available = await _instance.isAvailable();
    if (!available) {
      debugPrint('IAP not available');
      return;
    }

    _initialized = true;
    debugPrint('IAP initialized');

    // TODO: 구매 스트림 리스닝
    // _instance.purchaseStream.listen(_handlePurchaseUpdate);
  }

  /// 광고 제거 구매
  static Future<bool> purchaseAdRemoval() async {
    // TODO: 실제 IAP 구현
    debugPrint('Purchasing ad removal...');

    // 테스트: 즉시 성공 반환
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// 테마팩 구매
  static Future<bool> purchaseTheme(String themeId) async {
    // TODO: 실제 IAP 구현
    debugPrint('Purchasing theme: $themeId');

    // 테스트: 즉시 성공 반환
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// 구매 복원
  static Future<void> restorePurchases() async {
    // TODO: 실제 IAP 구현
    debugPrint('Restoring purchases...');
    await _instance.restorePurchases();
  }

  /// 구매 여부 확인 (로컬)
  static Future<bool> hasPurchased(String productId) async {
    // TODO: 실제 구매 여부 확인 (SharedPreferences 또는 Supabase)
    return false;
  }
}
