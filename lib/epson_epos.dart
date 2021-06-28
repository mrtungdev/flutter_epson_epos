import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class EpsonEpos {
  static const MethodChannel _channel = const MethodChannel('epson_epos');

  static bool _isDeviceSupport({bool throwError = false}) {
    if (Platform.isAndroid) return true;
    if (throwError) {
      throw PlatformException(code: "platformNotSupported", message: "Device not supported");
    }
    return false;
  }

  static Future<String?> get platformVersion async {
    if (!_isDeviceSupport(throwError: true)) return null;
    final String? version = await _channel.invokeMethod('getPlatformVersion');

    return version;
  }
}
