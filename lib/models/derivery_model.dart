// To parse this JSON data, do
//
//     final deliveries = deliveriesFromJson(jsonString);

import 'dart:convert';

import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/models/order_history_model.dart';
import 'package:soko_flow/models/orders_details_model.dart';

// Deliveries deliveriesFromJson(String str) => Deliveries.fromJson(json.decode(str));
List<DeliveriesModel> deliveriesFromJson(dynamic str) => List<DeliveriesModel>.from(
  (str).map(
        (e) => DeliveriesModel.fromJson(e),
  ),
);

// String deliveriesToJson(DeliveriesModel data) => json.encode(data.toJson());
class DeliveriesModel {
  DeliveriesModel({
    required this.id,
    required this.businessCode,
    required this.deliveryCode,
    required this.orderCode,
    required this.allocated,
    required this.deliveryNote,
    required this.deliveryStatus,
    required this.customer,
    this.order,
    this.deliveredTime,
    this.acceptAllocation,
    this.customerConfirmation,
    required this.createdBy,
    this.updatedBy,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryItems,
  });

  int id;
  String businessCode;
  String deliveryCode;
  String orderCode;
  String allocated;
  String? deliveryNote;
  String deliveryStatus;
  String type;
  CustomerDataModel customer;
  OrdersModel? order;
  dynamic deliveredTime;
  dynamic acceptAllocation;
  dynamic customerConfirmation;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<DeliveryItemModel> deliveryItems;

  factory DeliveriesModel.fromJson(Map<String, dynamic> json) {
    print("delivery");
    return DeliveriesModel(
      id: json["id"],
      businessCode: json["business_code"],
      deliveryCode: json["delivery_code"],
      orderCode: json["order_code"],
      allocated: json["allocated"],
      deliveryNote: json["delivery_note"] ?? "None",
      deliveryStatus: json["delivery_status"],
      customer: CustomerDataModel.fromJson(json["customer"]),
      deliveredTime: json["delivered_time"],
      acceptAllocation: json["accept_allocation"],
      customerConfirmation: json["customer_confirmation"],
      createdBy: json["created_by"],
      type: json["Type"] ?? "van_sale",
      order: OrdersModel.fromJson(json["order"]),
      updatedBy: json["updated_by"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deliveryItems: List<DeliveryItemModel>.from(json["delivery_items"].map((x) => DeliveryItemModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_code": businessCode,
    "delivery_code": deliveryCode,
    "order_code": orderCode,
    "allocated": allocated,
    "delivery_note": deliveryNote,
    "delivery_status": deliveryStatus,
    "customer": customer.toJson(),
    "delivered_time": deliveredTime,
    "accept_allocation": acceptAllocation,
    "customer_confirmation": customerConfirmation,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "delivery_items": List<dynamic>.from(deliveryItems.map((x) => x.toJson())),
  };
}


class DeliveryItemModel {
  DeliveryItemModel({
    this.id,
    this.businessCode,
    this.deliveryCode,
    this.deliveryItemCode,
    this.productId,
    this.productName,
    this.subTotal,
    this.totalAmount,
    this.sellingPrice,
    this.taxrate,
    this.allocatedQuantity,
    this.requestedQuantity,
    this.deliveryQuantity,
    this.itemCondition,
    this.note,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? businessCode;
  String? deliveryCode;
  String? deliveryItemCode;
  String? productId;
  String? productName;
  String? subTotal;
  String? totalAmount;
  String? sellingPrice;
  String? taxrate;
  String? allocatedQuantity;
  String? requestedQuantity;
  String? deliveryQuantity;
  String? itemCondition;
  String? note;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DeliveryItemModel.fromJson(Map<String, dynamic> json){
    print("delivery items");
    return DeliveryItemModel(
      id: json["id"],
      businessCode: json["business_code"],
      deliveryCode: json["delivery_code"],
      deliveryItemCode: json["delivery_item_code"],
      productId: json["productID"],
      productName: json["product_name"],
      subTotal: json["sub_total"],
      totalAmount: json["total_amount"],
      sellingPrice: json["selling_price"],
      taxrate: json["taxrate"],
      allocatedQuantity: json["allocated_quantity"].toString(),
      requestedQuantity: json["requested_quantity"],
      deliveryQuantity: json["delivery_quantity"],
      itemCondition: json["item_condition"],
      note: json["note"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_code": businessCode,
    "delivery_code": deliveryCode,
    "delivery_item_code": deliveryItemCode,
    "productID": productId,
    "product_name": productName,
    "sub_total": subTotal,
    "total_amount": totalAmount,
    "selling_price": sellingPrice,
    "taxrate": taxrate,
    "allocated_quantity": allocatedQuantity,
    "requested_quantity": requestedQuantity,
    "delivery_quantity": deliveryQuantity,
    "item_condition": itemCondition,
    "note": note,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class DeliveryCartModel {
  DeliveryCartModel({
    this.id,
    this.productId,
    this.productName,
    this.qty,
    this.allocatedQuantity,
    this.sellingPrice,
  });

  int? id;
  String? productId;
  String? productName;
  int? qty;
  int? allocatedQuantity;
  String? sellingPrice;

  double totalPrice(){
    // add your price calculation logic
    return double.parse(sellingPrice!) * qty!;
  }
}