// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'products_model.g.dart';

List<ProductsModel> productsFromJson(dynamic str) => List<ProductsModel>.from(
  (str).map(
        (e) => ProductsModel.fromJson(e),
  ),
);
// String productsModelToJson(ProductsModel data) => json.encode(data.toJson());


@HiveType(typeId: 16)
class ProductsModel extends HiveObject {
  @HiveField(0)
  int? region;

  @HiveField(1)
  int? productId;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  String? wholesalePrice;

  @HiveField(4)
  String? retailPrice;

  @HiveField(5)
  String? productName;

  @HiveField(6)
  int? stock;

  @HiveField(7)
  String? businessCode;

  @HiveField(8)
  String? skuCode;

  @HiveField(9)
  String? brand;

  @HiveField(10)
  String? category;
  @HiveField(11)
  int? distributorPrice;

  ProductsModel({
    this.region,
    this.productId,
    this.date,
    this.wholesalePrice,
    this.retailPrice,
    this.productName,
    this.stock,
    this.businessCode,
    this.skuCode,
    this.brand,
    this.category,
    this.distributorPrice
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    region: json["region"],
    productId: json["productID"],
    date: DateTime.parse(json["date"]),
    wholesalePrice: json["wholesale_price"],
    retailPrice: json["retail_price"],
    productName: json["product_name"],
    stock: json["stock"],
    businessCode: json["business_code"]!,
    skuCode: json["sku_code"],
    brand: json["brand"]?? "None",
    category: json["category"]!,
    distributorPrice: json["distributor_price"]
  );
}




