// To parse this JSON data, do
//
//     final checkoutFormModel = checkoutFormModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';

CheckoutFormModel checkoutFormModelFromJson(String str) => CheckoutFormModel.fromJson(json.decode(str));

String checkoutFormModelToJson(CheckoutFormModel data) => json.encode(data.toJson());

class CheckoutFormModel {
  List<NewSalesCart>? productsAvailable;
  List<NewSalesCart>? outOfStockProds;
  String? interestedInNewOrder;
  String? pricingAccuracy;
  String? incorrectPricingProductName;
  String? progressStatus;
  String? newInsights;
  String? productVisible;
  String? veryNextStep;
  File? image;

  CheckoutFormModel({
    this.productsAvailable,
    this.outOfStockProds,
    this.interestedInNewOrder,
    this.pricingAccuracy,
    this.incorrectPricingProductName,
    this.progressStatus,
    this.newInsights,
    this.veryNextStep,
    this.productVisible,
    this.image,
  });

  factory CheckoutFormModel.fromJson(Map<String, dynamic> json) => CheckoutFormModel(
    // productsAvailable: json["products_available"] == null ? [] : List<NewSalesCart>.from(json["products_available"]!.map((x) => NewSalesCart(price: price).fromJson(x))),
    // outOfStockProds: json["out_of_stock_prods"] == null ? [] : List<NewSalesCart>.from(json["out_of_stock_prods"]!.map((x) => Map.from(x).map((k, v) => MapEntry<String, int>(k, v)))),
    interestedInNewOrder: json["interested_in_new_order"],
    pricingAccuracy: json["pricing_accuracy"],
    incorrectPricingProductName: json["incorrect_pricing_product_name"],
    progressStatus: json["progress_status"],
    newInsights: json["new_insights"],
    productVisible: json["product_visible"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {

    // "products_available": productsAvailable == null ? [] : List<dynamic>.from(productsAvailable!.map((x) => x.toJson())),
    // "out_of_stock_prods": outOfStockProds == null ? [] : List<dynamic>.from(outOfStockProds!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    "interested_in_new_order": interestedInNewOrder,
    "pricing_accuracy": pricingAccuracy,
    "incorrect_pricing_product_name": incorrectPricingProductName,
    "progress_status": progressStatus,
    "new_insights": newInsights,
    "product_visible": productVisible,
    "very_next_step": veryNextStep,
    "image": image,
  };
}

