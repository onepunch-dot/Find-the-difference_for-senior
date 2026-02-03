import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

/// Google Mobile Ads 서비스
class AdService {
  static bool _initialized = false;
  static bool _isAdRemovalPurchased = false;

  /// AdMob 초기화
  static Future<void> initialize() async {
    if (_initialized) return;

    // 웹에서는 AdMob 지원 안함
    if (kIsWeb) {
      debugPrint('AdMob not supported on web');
      _initialized = true;
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      debugPrint('AdMob initialized');
    } catch (e) {
      debugPrint('AdMob initialization failed: $e');
      _initialized = true; // 에러가 나도 initialized로 처리
    }
  }

  /// 광고 제거 구매 여부 설정
  static void setAdRemovalPurchased(bool purchased) {
    _isAdRemovalPurchased = purchased;
  }

  /// 광고를 표시할지 여부
  static bool get shouldShowAds => !_isAdRemovalPurchased;

  /// 배너 광고 ID (테스트)
  static String get bannerAdUnitId {
    // TODO: 실제 AdMob ID로 교체
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/6300978111'; // 테스트 ID
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // 테스트 ID
    }
    return '';
  }

  /// 리워드 광고 ID (테스트)
  static String get rewardedAdUnitId {
    // TODO: 실제 AdMob ID로 교체
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/5224354917'; // 테스트 ID
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // 테스트 ID
    }
    return '';
  }
}
