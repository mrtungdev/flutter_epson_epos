import 'dart:convert';

///
/// Printer Model
///
class EpsonPrinterModel {
  EpsonPrinterModel({required this.address, this.type, this.model, this.series});

  /// Connectivity type: TCP | BT | USB
  String? type;

  /// Addrs
  String address;
  String? model;
  String? series;

  EpsonPrinterModel copyWith({required String address, String? type, String? model, String? series}) =>
      EpsonPrinterModel(address: address, type: type ?? this.type, model: model ?? this.model, series: series ?? this.series);

  factory EpsonPrinterModel.fromRawJson(String str) => EpsonPrinterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EpsonPrinterModel.fromJson(Map<String, dynamic> json) =>
      EpsonPrinterModel(address: json["address"], type: json["type"], model: json["model"], series: json["series"]);

  Map<String, dynamic> toJson() => {"address": address, "type": type, "model": model, "series": series};

  @override
  String toString() {
    return 'Model: $model Addr: $address Series: $series Port: $type';
  }
}

class EPSONSeries {
  String id;
  List<String> models;

  EPSONSeries({required this.id, required this.models});
}

///
/// Response
///
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

  factory EpsonPrinterResponse.fromRawJson(String str) => EpsonPrinterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EpsonPrinterResponse.fromJson(Map<String, dynamic> json) => EpsonPrinterResponse(
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
