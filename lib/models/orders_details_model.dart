
// To parse this JSON data, do
//
//     final orderData = orderDataFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:soko_flow/models/order_history_model.dart';


OrderDetailsData orderDataFromJson(String str) => OrderDetailsData.fromJson(json.decode(str));

String orderDataToJson(OrderDetailsData data) => json.encode(data.toJson());

class OrderDetailsData {
  OrderDetailsData({
    this.success,
    this.status,
    this.message,
    this.orderItems,
    this.payments
  });

  bool? success;
  int? status;
  String? message;
  List<OrderItem>? orderItems;
  List<PaymentModel>? payments;

  String? _message;
  bool? _success;
  late OrdersModel _order;
  OrdersModel get orderMade => _order;

  late List<OrderItem> _orderItems;
  List<OrderItem> get ordersList => _orderItems;

  late List<PaymentModel> _orderPayment;
  List<PaymentModel> get orderPayments  => _orderPayment;

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['items'] != null ) {
      print("the json items : ${json['items']}");
      _orderItems = <OrderItem>[];
      json['items'].forEach((v) {
        _orderItems.add(OrderItem.fromJson(v));
      });
      print("model type items: $_orderItems");
      _order = OrdersModel.fromJson(json["Data"]);

      _orderPayment = <PaymentModel>[];
      json['Payment'].forEach((v) {
        _orderPayment.add(PaymentModel.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "order_items": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 17)
class OrderItem {
  OrderItem({
    this.id,
    // this.orderCode,
    this.productId,
    this.productName,
    this.quantity,
    // this.subTotal,
    this.totalAmount,
    this.sellingPrice,
    this.discount,
    this.taxrate,
    this.taxvalue,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  int? id;
  @HiveField(2)
  int? productId;
  @HiveField(3)
  String? productName;
  @HiveField(4)
  int? quantity;
  @HiveField(6)
  String? totalAmount;
  @HiveField(7)
  String? sellingPrice;
  @HiveField(8)
  String? discount;
  @HiveField(9)
  int? taxrate;
  @HiveField(10)
  String? taxvalue;
  @HiveField(11)
  DateTime? createdAt;
  @HiveField(12)
  DateTime? updatedAt;
  @HiveField(13)
  String? orderId;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    // orderCode: json["order_code"],
    productId: json["productID"],
    productName: json["product_name"],
    quantity: json["quantity"],
    totalAmount: json["total_amount"],
    sellingPrice: json["selling_price"],
    discount: json["discount"],
    taxrate: json["taxrate"],
    taxvalue: json["taxvalue"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productID": productId,
    "product_name": productName,
    "quantity": quantity,
    "total_amount": totalAmount,
    "selling_price": sellingPrice,
    "discount": discount,
    "taxrate": taxrate,
    "taxvalue": taxvalue,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

@HiveType(typeId: 18)
class PaymentModel {
  PaymentModel({
    this.amount,
    this.balance,
    this.bankCharges,
    this.paymentDate,
    this.paymentMethod,
    this.referenceNumber,
    this.orderId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(13)
  String? amount;
  @HiveField(14)
  String? balance;
  @HiveField(15)
  dynamic bankCharges;
  @HiveField(16)
  DateTime? paymentDate;
  @HiveField(17)
  String? paymentMethod;
  @HiveField(18)
  String? referenceNumber;
  @HiveField(19)
  String? orderId;
  @HiveField(20)
  int? userId;
  @HiveField(21)
  DateTime? createdAt;
  @HiveField(22)
  DateTime? updatedAt;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    amount: json["amount"],
    balance: json["balance"],
    bankCharges: json["bank_charges"],
    paymentDate: DateTime.parse(json["payment_date"]),
    paymentMethod: json["payment_method"],
    referenceNumber: json["reference_number"] == null ? null : json["reference_number"],
    orderId: json["order_id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "balance": balance,
    "bank_charges": bankCharges,
    "payment_date": "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    "payment_method": paymentMethod,
    "reference_number": referenceNumber == null ? null : referenceNumber,
    "order_id": orderId,
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

