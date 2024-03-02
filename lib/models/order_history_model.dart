// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);
//
// import 'dart:convert';
//
// OrderHistory orderHistoryFromJson(String str) => OrderHistory.fromJson(json.decode(str));
//
// String orderHistoryToJson(OrderHistory data) => json.encode(data.toJson());
//
// class OrderHistory {
//   OrderHistory({
//     this.success,
//     this.status,
//     this.message,
//     this.orders,
//   });
//
//   bool? success;
//   int? status;
//   String? message;
//   List<OrderModel>? orders;
//
//   bool? _success;
//   String? _message;
//   late List<OrderModel> _orders;
//   List<OrderModel> get ordersList => _orders;
//
//
//   OrderHistory.fromJson(Map<String, dynamic> json) {
//     _success = json['success'];
//     _message = json['message'];
//     if (json['orders'] != null) {
//       _orders = <OrderModel>[];
//       json['orders'].forEach((v) {
//         _orders.add(OrderModel.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "status": status,
//     "message": message,
//     "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
//   };
// }
//
// class OrderModel {
//   OrderModel({
//     this.id,
//     this.orderCode,
//     this.userCode,
//     this.customerId,
//     this.priceTotal,
//     this.balance,
//     this.discount,
//     this.note,
//     this.orderStatus,
//     this.paymentStatus,
//     this.qty,
//     this.checkinCode,
//     this.orderType,
//     this.reasonsPartialDelivery,
//     this.cancellationReason,
//     this.deliveryDate,
//     this.businessCode,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? orderCode;
//   String? userCode;
//   int? customerId;
//   String? priceTotal;
//   String? balance;
//   double? discount;
//   double? note;
//   String? orderStatus;
//   String? paymentStatus;
//   int? qty;
//   String? checkinCode;
//   String? orderType;
//   String? reasonsPartialDelivery;
//   String? cancellationReason;
//   String? deliveryDate;
//   String? businessCode;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
//     id: json["id"],
//     orderCode: json["order_code"],
//     userCode: json["user_code"],
//     customerId: json["customerID"],
//     priceTotal: json["price_total"],
//     balance: json["balance"],
//     discount: json["discount"],
//     note: json["note"],
//     orderStatus: json["order_status"],
//     paymentStatus: json["payment_status"],
//     qty: json["qty"],
//     checkinCode: json["checkin_code"],
//     orderType: json["order_type"],
//     reasonsPartialDelivery: json["reasons_partial_delivery"],
//     cancellationReason: json["cancellation_reason"],
//     deliveryDate: json["delivery_date"],
//     businessCode: json["business_code"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "order_code": orderCode,
//     "user_code": userCode,
//     "customerID": customerId,
//     "price_total": priceTotal,
//     "balance": balance,
//     "discount": discount,
//     "note": note,
//     "order_status": orderStatus,
//     "payment_status": paymentStatus,
//     "qty": qty,
//     "checkin_code": checkinCode,
//     "order_type": orderType,
//     "reasons_partial_delivery": reasonsPartialDelivery,
//     "cancellation_reason": cancellationReason,
//     "delivery_date": deliveryDate,
//     "business_code": businessCode,
//     "created_at": createdAt!.toIso8601String(),
//     "updated_at": updatedAt!.toIso8601String(),
//   };
// }

// To parse this JSON data, do
//
//     final orderData = orderDataFromJson(jsonString);


import 'dart:convert';

import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/models/distributors_model.dart';

OrderData orderDataFromJson(String str) => OrderData.fromJson(json.decode(str));

String orderDataToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
  OrderData({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<OrdersModel>? data;

  bool? _success;
  String? _message;
  late List<OrdersModel> _orders;
  List<OrdersModel> get ordersList => _orders;

  OrderData.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['Data'] != null) {
      _orders = <OrdersModel>[];
      json['Data'].forEach((v) {
        _orders.add(OrdersModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OrdersModel {
  OrdersModel({
    this.customerId,
    this.orderCode,
    this.userCode,
    this.priceTotal,
    this.balance,
    this.orderStatus,
    this.paymentStatus,
    this.distributor,
    this.customer,
    this.checkinCode,
    this.orderType,
    this.createdAt,
  });

  int? customerId;
  String? orderCode;
  String? userCode;
  String? priceTotal;
  String? balance;
  String? orderStatus;
  String? paymentStatus;
  String? checkinCode;
  DistributorsModel? distributor;
  CustomerDataModel? customer;
  String? orderType;
  DateTime? createdAt;

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      customerId: json["customerID"] ?? 0,
      orderCode: json["order_code"],
      userCode: json["user_code"],
      priceTotal: json["price_total"] ?? "",
      balance: json["balance"] ?? "0",
      orderStatus: json["order_status"],
      paymentStatus: json["payment_status"],
      distributor:json.containsKey("distributor") && json["distributor"] !=null ?DistributorsModel.fromMap(json["distributor"]):null,
      customer: json.containsKey("customer")?CustomerDataModel.fromJson(json["customer"]):null,
      checkinCode: json["checkin_code"],
      orderType: json["order_type"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "customerID": customerId,
    "user_code": userCode,
    "price_total": priceTotal,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "checkin_code": checkinCode,
    "order_type": orderType,
    "created_at": createdAt!.toIso8601String(),
  };
}

