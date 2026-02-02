import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// 고유 기기 ID 가져오기 (로컬 생성 및 저장)
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');

    if (deviceId != null) {
      return deviceId;
    }

    // 기기 정보 기반으로 ID 생성
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceId = 'android_${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceId = 'ios_${iosInfo.identifierForVendor ?? DateTime.now().millisecondsSinceEpoch.toString()}';
      } else {
        deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      }

      await prefs.setString('device_id', deviceId);
      return deviceId;
    } catch (e) {
      // 기기 정보 가져오기 실패 시 타임스탬프 기반 ID 생성
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('device_id', deviceId);
      return deviceId;
    }
  }
}
