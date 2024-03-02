// To parse this JSON data, do
//
//     final receiveStock = receiveStockFromJson(jsonString);

import 'dart:convert';

ReceiveStock receiveStockFromJson(String str) => ReceiveStock.fromJson(json.decode(str));

String receiveStockToJson(ReceiveStock data) => json.encode(data.toJson());

class ReceiveStock {
  ReceiveStock({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<ReceiveStockModel>? data;

  bool? _success;
  String? _message;
  late List<ReceiveStockModel> _receiveStockItems;
  List<ReceiveStockModel> get  receiveStockItems=> _receiveStockItems;

  ReceiveStock.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _receiveStockItems = <ReceiveStockModel>[];
      json['data'].forEach((v) {
        _receiveStockItems.add(ReceiveStockModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReceiveStockModel {
  ReceiveStockModel({
    this.productId,
    this.productName,
    this.status,
    this.dateAllocated,
    this.quantityAllocated,
    this.businessCode,
  });

  int? productId;
  String? productName;
  String? status;
  dynamic dateAllocated;
  String? quantityAllocated;
  String? businessCode;

  factory ReceiveStockModel.fromJson(Map<String, dynamic> json) => ReceiveStockModel(
    productId: json["product ID"],
    productName: json["Product Name"],
    status: json["status"],
    dateAllocated: json["date_allocated"],
    quantityAllocated: json["Quantity Allocated"],
    businessCode: json["business_code"],
  );

  Map<String, dynamic> toJson() => {
    "product ID": productId,
    "Product Name": productName,
    "status": status,
    "date_allocated": dateAllocated,
    "Quantity Allocated": quantityAllocated,
    "business_code": businessCode,
  };
}




