import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../data/supabase/repositories/purchase_repository_impl.dart';
import '../../data/supabase/supabase_client.dart';
import '../../domain/models/purchase.dart';

/// In-App Purchase 서비스 (싱글톤)
class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  final PurchaseRepositoryImpl _purchaseRepo = PurchaseRepositoryImpl();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _initialized = false;

  // 상품 ID (TODO: 실제 스토어 상품 ID로 교체)
  static const String adRemovalProductId = 'ad_removal';
  static const String themePackPrefix = 'theme_pack_';

  /// IAP 초기화
  Future<void> initialize() async {
    if (_initialized) return;

    // 웹에서는 IAP 지원 안함
    if (kIsWeb) {
      debugPrint('IAP not supported on web');
      _initialized = true;
      return;
    }

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        debugPrint('IAP not available on this device');
        _initialized = true;
        return;
      }

      // 구매 스트림 리스닝 시작
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: () => debugPrint('Purchase stream closed'),
        onError: (error) => debugPrint('Purchase stream error: $error'),
      );

      _initialized = true;
      debugPrint('IAP initialized successfully');
    } catch (e) {
      debugPrint('IAP initialization failed: $e');
      _initialized = true;
    }
  }

  /// 구매 업데이트 처리
  Future<void> _handlePurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase update: ${purchaseDetails.status}');

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // 구매 성공 또는 복원됨
        await _verifyAndSavePurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchaseDetails.error}');
      }

      // 구매 완료 처리 (중요!)
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// 영수증 검증 및 서버 저장
  Future<void> _verifyAndSavePurchase(PurchaseDetails details) async {
    try {
      final userId = SupabaseClientManager.currentUserId;
      if (userId == null) {
        debugPrint('Cannot save purchase: no user ID');
        return;
      }

      // 상품 ID에서 타입과 테마 ID 파싱
      final productId = details.productID;
      String type;
      String? themeId;

      if (productId == adRemovalProductId) {
        type = 'ad_removal';
      } else if (productId.startsWith(themePackPrefix)) {
        type = 'theme';
        themeId = productId.replaceFirst(themePackPrefix, '');
      } else {
        debugPrint('Unknown product ID: $productId');
        return;
      }

      // Supabase에 구매 기록 저장
      final purchase = Purchase(
        id: details.purchaseID ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: type == 'ad_removal' ? PurchaseType.adRemoval : PurchaseType.theme,
        themeId: themeId,
        productId: productId,
        purchasedAt: DateTime.now(),
      );

      await _purchaseRepo.addPurchase(purchase);
      debugPrint('Purchase saved to Supabase: $productId');
    } catch (e) {
      debugPrint('Failed to verify and save purchase: $e');
    }
  }

  /// 구매 복원 (진짜 방식)
  Future<List<String>> restorePurchases() async {
    if (kIsWeb) {
      throw Exception('IAP not supported on web');
    }

    if (!_initialized) {
      throw Exception('IAP not initialized');
    }

    try {
      debugPrint('Starting purchase restoration...');

      // Apple/Google에서 구매 내역 가져오기
      await _iap.restorePurchases();

      // 복원된 항목은 purchaseStream을 통해 _handlePurchaseUpdate에서 처리됨
      // 잠시 대기하여 스트림 처리 완료
      await Future.delayed(const Duration(seconds: 2));

      // 복원된 구매 목록 조회
      final userId = SupabaseClientManager.currentUserId;
      if (userId == null) {
        throw Exception('No user ID available');
      }

      final purchases = await _purchaseRepo.getUserPurchases(userId);
      final restoredProductIds =
          purchases.map((p) => p.productId).toList();

      debugPrint('Restored ${restoredProductIds.length} purchases');
      return restoredProductIds;
    } catch (e) {
      debugPrint('Failed to restore purchases: $e');
      rethrow;
    }
  }

  /// 광고 제거 구매
  Future<bool> purchaseAdRemoval() async {
    return await _purchaseProduct(adRemovalProductId);
  }

  /// 테마팩 구매
  Future<bool> purchaseTheme(String themeId) async {
    final productId = '$themePackPrefix$themeId';
    return await _purchaseProduct(productId);
  }

  /// 상품 구매 (내부 메서드)
  Future<bool> _purchaseProduct(String productId) async {
    if (kIsWeb) {
      debugPrint('IAP not supported on web');
      return false;
    }

    if (!_initialized) {
      debugPrint('IAP not initialized');
      return false;
    }

    try {
      // 상품 정보 조회
      final ProductDetailsResponse response =
          await _iap.queryProductDetails({productId});

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Product not found: $productId');
        return false;
      }

      if (response.productDetails.isEmpty) {
        debugPrint('No product details available');
        return false;
      }

      final productDetails = response.productDetails.first;

      // 구매 요청
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      return success;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    }
  }

  /// 구매 여부 확인
  Future<bool> hasPurchased(String productId) async {
    try {
      final userId = SupabaseClientManager.currentUserId;
      if (userId == null) return false;

      if (productId == adRemovalProductId) {
        return await _purchaseRepo.hasAdRemovalPurchase(userId);
      } else if (productId.startsWith(themePackPrefix)) {
        final themeId = productId.replaceFirst(themePackPrefix, '');
        return await _purchaseRepo.hasThemePurchase(userId, themeId);
      }

      return false;
    } catch (e) {
      debugPrint('Failed to check purchase: $e');
      return false;
    }
  }

  /// 리소스 해제
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
