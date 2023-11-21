// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

///
/// Printer Model
///
class EpsonPrinterModel {
  /// Connectivity type: TCP | BT | USB
  String? type;

  /// Addrs
  String? ipAddress;
  String? bdAddress;
  String? macAddress;
  String? model;
  String? series;
  String? target;
  EpsonPrinterModel({
    this.type,
    this.ipAddress,
    this.bdAddress,
    this.macAddress,
    this.model,
    this.series,
    this.target,
  });

  EpsonPrinterModel copyWith({
    String? type,
    String? ipAddress,
    String? bdAddress,
    String? macAddress,
    String? model,
    String? series,
    String? target,
  }) {
    return EpsonPrinterModel(
      type: type ?? this.type,
      ipAddress: ipAddress ?? this.ipAddress,
      bdAddress: bdAddress ?? this.bdAddress,
      macAddress: macAddress ?? this.macAddress,
      model: model ?? this.model,
      series: series ?? this.series,
      target: target ?? this.target,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'ipAddress': ipAddress,
      'bdAddress': bdAddress,
      'macAddress': macAddress,
      'model': model,
      'series': series,
      'target': target,
    };
  }

  factory EpsonPrinterModel.fromMap(Map<String, dynamic> map) {
    return EpsonPrinterModel(
      type: map['type'] != null ? map['type'] as String : null,
      ipAddress: map['ipAddress'] != null ? map['ipAddress'] as String : null,
      bdAddress: map['bdAddress'] != null ? map['bdAddress'] as String : null,
      macAddress:
          map['macAddress'] != null ? map['macAddress'] as String : null,
      model: map['model'] != null ? map['model'] as String : null,
      series: map['series'] != null ? map['series'] as String : null,
      target: map['target'] != null ? map['target'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EpsonPrinterModel.fromJson(String source) =>
      EpsonPrinterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EpsonPrinterModel(type: $type, ipAddress: $ipAddress, bdAddress: $bdAddress, macAddress: $macAddress, model: $model, series: $series, target: $target)';
  }

  @override
  bool operator ==(covariant EpsonPrinterModel other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.ipAddress == ipAddress &&
        other.bdAddress == bdAddress &&
        other.macAddress == macAddress &&
        other.model == model &&
        other.series == series &&
        other.target == target;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        ipAddress.hashCode ^
        bdAddress.hashCode ^
        macAddress.hashCode ^
        model.hashCode ^
        series.hashCode ^
        target.hashCode;
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
