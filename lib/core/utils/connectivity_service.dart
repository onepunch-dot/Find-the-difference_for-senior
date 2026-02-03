import 'dart:async';
import 'package:flutter/foundation.dart';

/// 네트워크 연결 상태 관리 서비스
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  bool _isOnline = true;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  /// 온라인 상태로 설정 (테스트용)
  void setOnline(bool online) {
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
      debugPrint('Network status: ${online ? 'Online' : 'Offline'}');
    }
  }

  /// 네트워크 체크 (간단한 구현)
  Future<bool> checkConnectivity() async {
    // TODO: 실제 네트워크 체크 구현
    // connectivity_plus 패키지 사용 권장
    return _isOnline;
  }

  /// 오프라인 안내 메시지
  static String get offlineMessage => '인터넷 연결을 확인해주세요.';
}
