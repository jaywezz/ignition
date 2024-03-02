import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';

part 'add_to_cart_model.g.dart';


// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

// List<Cart> cartFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<NewSalesCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 10)
class NewSalesCart {
  NewSalesCart({
    this.productMo,
    this.qty,
    required this.price
  });

  @HiveField(0)
  ProductsModel? productMo;
  @HiveField(1)
  int? qty;
  @HiveField(2)
  String price;

  // factory Cart.fromJson(Map<String, dynamic> json) => Cart(
  //   productId: json["productID"],
  //   qty: json["qty"],
  // );

  Map<String, dynamic> toJson() => {
    "productID": productMo!.productId,
    "qty": qty,
    "price": price
  };

  double totalPrice(){
    // add your price calculation logic
    return double.parse(price.toString()) * qty!;
  }
}

@HiveType(typeId: 9)
class VanSalesCart {
  VanSalesCart({
    this.latestAllocationModel,
    this.qty,
    required this.price
  });

  @HiveField(0)
  LatestAllocationModel? latestAllocationModel;
  @HiveField(1)
  int? qty;
  @HiveField(2)
  int? price;

  // factory Cart.fromJson(Map<String, dynamic> json) => Cart(
  //   productId: json["productID"],
  //   qty: json["qty"],
  // );

  Map<String, dynamic> toJson() => {
    "productID": latestAllocationModel!.id,
    "qty": qty,
    "price": price
  };

  double totalPrice(){
    // add your price calculation logic
    return double.parse(price.toString()) * qty!;
  }
}



@HiveType(typeId: 9)
class ReconcileCart {
  ReconcileCart({
    this.latestAllocationModel,
    this.qty,
    this.supplierId
  });

  @HiveField(0)
  LatestAllocationModel? latestAllocationModel;
  @HiveField(1)
  int? qty;
  String? supplierId;

  // factory Cart.fromJson(Map<String, dynamic> json) => Cart(
  //   productId: json["productID"],
  //   qty: json["qty"],
  // );

  Map<String, dynamic> toJson() => {
    "productID": latestAllocationModel!.id,
    "amount": qty,
    "supplierID": supplierId
  };

}

