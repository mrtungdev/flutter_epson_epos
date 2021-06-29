import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class EpsonEPOS {
  static const MethodChannel _channel = const MethodChannel('epson_epos');

  static bool _isPrinterPlatformSupport({bool throwError = false}) {
    if (Platform.isAndroid) return true;
    if (throwError) {
      throw PlatformException(
          code: "platformNotSupported", message: "Device not supported");
    }
    return false;
  }

  static Future<dynamic> onDiscovery() async {
    if (!_isPrinterPlatformSupport(throwError: true)) return null;
    try {
      final rep = await _channel.invokeMethod('onDiscovery');
      return rep;
    } catch (e) {
      throw e;
    }
  }
}
