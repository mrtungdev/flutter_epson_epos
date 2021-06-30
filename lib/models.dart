import 'dart:convert';

/*
 * Star Micronics Printer Model
 */
class EpsonPrinterModel {
  EpsonPrinterModel({required this.address, this.portName, this.model});

  String address;
  String? portName;
  String? model;

  EpsonPrinterModel copyWith(
          {required String address, String? portName, String? model}) =>
      EpsonPrinterModel(
          address: address,
          portName: portName ?? this.portName,
          model: model ?? this.model);

  factory EpsonPrinterModel.fromRawJson(String str) =>
      EpsonPrinterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EpsonPrinterModel.fromJson(Map<String, dynamic> json) =>
      EpsonPrinterModel(
          address: json["address"] == null ? null : json["address"],
          portName: json["portName"] == null ? null : json["portName"],
          model: json["model"] == null ? null : json["model"]);

  Map<String, dynamic> toJson() => {
        "address": address,
        "portName": portName == null ? null : portName,
        "model": model == null ? null : model
      };
}

class EpsonPrinterResponse {
  EpsonPrinterResponse({
    required this.type,
    required this.success,
    this.message,
    this.content,
  });

  String type;
  bool success;
  String? message;
  dynamic content;

  EpsonPrinterResponse copyWith({
    required String type,
    required bool success,
    String? message,
    dynamic content,
  }) =>
      EpsonPrinterResponse(
        type: type,
        success: success,
        message: message ?? this.message,
        content: content ?? this.content,
      );

  factory EpsonPrinterResponse.fromRawJson(String str) =>
      EpsonPrinterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EpsonPrinterResponse.fromJson(Map<String, dynamic> json) =>
      EpsonPrinterResponse(
        type: json["type"] == null ? null : json["type"],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        content: json["content"] == null ? null : json["content"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "success": success,
        "message": message == null ? null : message,
        "content": content == null ? null : content,
      };
}
