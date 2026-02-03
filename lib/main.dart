import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/supabase/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드 고정 (설정에서 회전 허용 가능)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Supabase 초기화
  await SupabaseClientManager.initialize();

  // 추후 추가될 초기화:
  // - Google Mobile Ads 초기화

  runApp(const MyApp());
}
