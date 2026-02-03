import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/supabase/supabase_client.dart';
import 'features/ads/ad_service.dart';
import 'features/purchase/iap_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드 고정 (설정에서 회전 허용 가능)
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint('Failed to set orientation: $e');
  }

  // Supabase 초기화
  try {
    await SupabaseClientManager.initialize();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  // Google Mobile Ads 초기화
  try {
    await AdService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize AdService: $e');
  }

  // In-App Purchase 초기화
  try {
    await IAPService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize IAPService: $e');
  }

  runApp(const MyApp());
}
