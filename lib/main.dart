import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드 고정 (설정에서 회전 허용 가능)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 추후 추가될 초기화:
  // - Supabase 초기화
  // - Google Mobile Ads 초기화
  // - 로컬 스토리지 초기화

  runApp(const MyApp());
}
