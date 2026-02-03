import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/supabase/supabase_client.dart';
import 'features/ads/ad_service.dart';
import 'features/purchase/iap_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드 고정 (설정에서 회전 허용 가능)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Supabase 초기화
  await SupabaseClientManager.initialize();

  // Google Mobile Ads 초기화
  await AdService.initialize();

  // In-App Purchase 초기화
  await IAPService.initialize();

  runApp(const MyApp());
}
