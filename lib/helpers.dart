import 'enums.dart';
import 'const.dart';
import 'models.dart';

class EpsonEPOSHelper {
  EpsonEPOSHelper();

  dynamic getPortType(EpsonEPOSPortType enumData, {bool returnInt = false}) {
    switch (enumData) {
      case EpsonEPOSPortType.TCP:
        return returnInt ? 1 : 'TCP';
      case EpsonEPOSPortType.BLUETOOTH:
        return returnInt ? 2 : 'BT';
      case EpsonEPOSPortType.USB:
        return returnInt ? 3 : 'USB';
      default:
        return returnInt ? 0 : 'ALL';
    }
  }

  EPSONSeries? getSeries(String modelName) {
    if (modelName.isEmpty) return null;
    return epsonSeries.firstWhere(
        (element) => element.models.contains(modelName),
        orElse: null);
  }
}
