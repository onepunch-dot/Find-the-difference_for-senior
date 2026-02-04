import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/supabase/supabase_client.dart';
import 'features/ads/ad_service.dart';
import 'features/purchase/iap_service.dart';
import 'features/audio/bgm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 화면 회전 허용 (모든 방향)
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
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
    await IAPService().initialize();
  } catch (e) {
    debugPrint('Failed to initialize IAPService: $e');
  }

  // BGM 서비스 초기화
  try {
    await BGMService().initialize();
  } catch (e) {
    debugPrint('Failed to initialize BGMService: $e');
  }

  runApp(const MyApp());
}
