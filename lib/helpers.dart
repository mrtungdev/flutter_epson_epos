import 'enums.dart';

class EpsonEPOSHelper {
  EpsonEPOSHelper();

  dynamic getPortType(EpsonEPOSPortType enumData, {bool returnInt = false}) {
    switch (enumData) {
      case EpsonEPOSPortType.TCP:
        return returnInt ? 1 : 'tcp';
      case EpsonEPOSPortType.BLUETOOTH:
        return returnInt ? 2 : 'bluetooth';
      case EpsonEPOSPortType.USB:
        return returnInt ? 3 : 'usb';
      default:
        return returnInt ? 0 : 'all';
    }
  }
}
