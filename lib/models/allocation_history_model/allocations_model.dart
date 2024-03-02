// To parse this JSON data, do
//
//     final allocations = allocationsFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'allocations_model.g.dart';

Allocations allocationsFromJson(String str) => Allocations.fromJson(json.decode(str));

String allocationsToJson(Allocations data) => json.encode(data.toJson());

class Allocations {
  Allocations({
    this.success,
    this.allocationHistory,
    this.message,
  });

  bool? success;
  List<AllocationHistoryModel>? allocationHistory;
  String? message;

  bool? _success;
  String? _message;
  late List<AllocationHistoryModel> _allocationHistory;
  List<AllocationHistoryModel> get allocationsHist => _allocationHistory;

  Allocations.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['allocation_history'] != null) {
      _allocationHistory = <AllocationHistoryModel>[];
      json['allocation_history'].forEach((v) {
        _allocationHistory.add(AllocationHistoryModel.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() => {
    "success": success,
    "allocation_history": List<dynamic>.from(allocationHistory!.map((x) => x.toJson())),
    "message": message,
  };
}

@HiveType(typeId: 4)
class AllocationHistoryModel {
  AllocationHistoryModel({
    this.productName,
    this.brand,
    this.allocationCode,
    this.sellingPrice,
    this.buyingPrice,
    this.currentQty,
    this.skuCode,
    this.allocatedQty,
    this.createdAt,
  });

  @HiveField(0)
  String? productName;
  @HiveField(1)
  String? brand;
  @HiveField(2)
  String? allocationCode;
  @HiveField(3)
  String? buyingPrice;
  @HiveField(4)
  String? sellingPrice;
  @HiveField(5)
  String? skuCode;
  @HiveField(6)
  int? currentQty;
  @HiveField(7)
  String? allocatedQty;
  @HiveField(8)
  DateTime? createdAt;
  factory AllocationHistoryModel.fromJson(Map<String, dynamic> json) => AllocationHistoryModel(
    productName: json["product_name"],
    brand: json["brand"],
    allocationCode: json["allocation_code"],
    buyingPrice: json["buying_price"],
    sellingPrice: json["selling_price"],
    skuCode: json["sku_code"],
    currentQty: json["current_qty"],
    allocatedQty: json["allocated_qty"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "brand": brand,
    "allocation_code": allocationCode,
    "buying_price": buyingPrice,
    "selling_price": sellingPrice,
    "sku_code": skuCode,
    "current_qty": currentQty,
    "allocated_qty": allocatedQty,
    "created_at": createdAt!.toIso8601String(),
  };
}
