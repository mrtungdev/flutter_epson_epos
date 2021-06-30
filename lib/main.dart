import 'dart:developer';

import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'enums.dart';
import 'helpers.dart';
import 'models.dart';

class EpsonEPOS {
  static const MethodChannel _channel = const MethodChannel('epson_epos');

  static EpsonEPOSHelper _eposHelper = EpsonEPOSHelper();

  static bool _isPrinterPlatformSupport({bool throwError = false}) {
    if (Platform.isAndroid) return true;
    if (throwError) {
      throw PlatformException(
          code: "platformNotSupported", message: "Device not supported");
    }
    return false;
  }

  static Future<List<EpsonPrinterModel>?> onDiscovery(
      {EpsonEPOSPortType type = EpsonEPOSPortType.ALL}) async {
    if (!_isPrinterPlatformSupport(throwError: true)) return null;
    String printType = _eposHelper.getPortType(type);
    final Map<String, dynamic> params = {"type": printType};
    String? rep = await _channel.invokeMethod('onDiscovery', params);
    if (rep != null) {
      try {
        final response = EpsonPrinterResponse.fromRawJson(rep);
        List<dynamic> prs = response.content;
        if (prs.length > 0) {
          return prs
              .map((e) => EpsonPrinterModel(
                  address: e['address'],
                  portName: e['macAddress'],
                  model: e['model']))
              .toList();
        }
      } catch (e) {
        throw e;
      }
    }
    return [];
  }
}
