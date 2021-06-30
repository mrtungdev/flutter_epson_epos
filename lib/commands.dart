// import 'enums.dart';

class StarMicronicsCommand {
  // String _enumText(dynamic enumName) {
  //   List<String> ns = enumName.toString().split('.');
  //   if (ns.length > 0) {
  //     return ns.last;
  //   }
  //   return enumName.toString();
  // }

  Map<String, dynamic> append(dynamic data) {
    return {"id": "appendText", "value": data};
  }

  Map<String, dynamic> appendBitmap(dynamic data, int width, int height, int posX, int posY) {
    Map<String, dynamic> cmd = {"id": "addImage", "value": data};
    cmd['width'] = width;
    cmd['height'] = height;
    cmd['posX'] = posX;
    cmd['posY'] = posY;

    return cmd;
  }
}
