// To parse this JSON data, do
//
//     final allocations = allocationsFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'latest_allocated_items_model.g.dart';

LatestAllocations latestAllocationsFromJson(String str) => LatestAllocations.fromJson(json.decode(str));

// String latestAllocationsToJson(LatestAllocations data) => json.encode(data.toJson());

class LatestAllocations {
  LatestAllocations({
    this.success,
    this.latestAllocation,
    this.message,
  });

  bool? success;
  List<LatestAllocationModel>? latestAllocation;
  String? message;

  bool? _success;
  String? _message;
  late List<LatestAllocationModel> _latestAllocation;
  List<LatestAllocationModel> get latestAllocations => _latestAllocation;

  LatestAllocations.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['latest_allocated_item'] != null) {
      _latestAllocation = <LatestAllocationModel>[];
      json['latest_allocated_item'].forEach((v) {
        _latestAllocation.add(LatestAllocationModel.fromJson(v));
      });
    }
  }


  // Map<String, dynamic> toJson() => {
  //   "success": success,
  //   "latest_allocated_item": List<dynamic>.from(latestAllocation!.map((x) => x.toJson())),
  //   "message": message,
  // };
}

@HiveType(typeId: 3)
class LatestAllocationModel {
  LatestAllocationModel({
    this.id,
    this.productName,
    this.brand,
    this.allocationCode,
    this.category,
    this.retailPrice,
    this.wholeSalePrice,
    this.distributorPrice,
    this.currentQty,
    this.skuCode,
    this.allocatedQty,
    this.createdAt,
  });


  @HiveField(0)
  int? id;
  @HiveField(1)
  String? productName;
  @HiveField(2)
  String? brand;
  @HiveField(3)
  String? category;
  @HiveField(4)
  String? allocationCode;
  @HiveField(5)
  String? retailPrice;
  @HiveField(6)
  String? wholeSalePrice;
  @HiveField(7)
  String? skuCode;
  @HiveField(8)
  int? currentQty;
  @HiveField(9)
  String? allocatedQty;
  @HiveField(10)
  DateTime? createdAt;
  @HiveField(11)
  String? distributorPrice;

  factory LatestAllocationModel.fromJson(Map<String, dynamic> json) => LatestAllocationModel(
    id:  json["id"],
    productName: json["product_name"],
    brand: json["brand"],
    category: json["category"],
    allocationCode: json["allocation_code"],
    wholeSalePrice: json["wholesale_price"],
    retailPrice: json["retailer_price"],
    distributorPrice: json["distributor_price"].toString(),
    skuCode: json["sku_code"],
    currentQty: json["current_qty"],
    allocatedQty: json["allocated_qty"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "product_name": productName,
  //   "brand": brand,
  //   "category": category,
  //   "allocation_code": allocationCode,
  //   "buying_price": buyingPrice,
  //   "selling_price": sellingPrice,
  //   "sku_code": skuCode,
  //   "current_qty": currentQty,
  //   "allocated_qty": allocatedQty,
  //   "created_at": createdAt!.toIso8601String(),
  // };
}
