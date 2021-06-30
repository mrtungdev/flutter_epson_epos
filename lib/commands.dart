import 'enums.dart';

class StarMicronicsCommand {
  String _enumText(dynamic enumName) {
    List<String> ns = enumName.toString().split('.');
    if (ns.length > 0) {
      return ns.last;
    }
    return enumName.toString();
  }

  Map<String, dynamic> append(dynamic data) {
    return {"id": "append", "value": data};
  }

  Map<String, dynamic> appendRaw(dynamic data) {
    return {"id": "appendRaw", "value": data};
  }
}
