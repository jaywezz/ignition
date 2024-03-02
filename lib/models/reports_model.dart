// To parse this JSON data, do
//
//     final reports = reportsFromJson(jsonString);

import 'dart:convert';


FormsData formsDataFromJson(dynamic str) {
  print("here $str");
  return FormsData.fromJson(json.decode(str));
}

String formsDataToJson(FormsData data) => json.encode(data.toJson());

class FormsData {
  FormsData({
    this.data,
  });

  Reports? data;

  factory FormsData.fromJson(Map<String, dynamic> json) {
    print("this point $json");
    return FormsData(
      data: Reports.fromJson(json["Data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "Data": data!.toJson(),
  };
}

class Reports {
  Reports({
    this.ordersToday,
    this.ordersWeekly,
    this.ordersMonthly,
    this.totalSalesToday,
    this.totalSalesWeekly,
    this.totalSalesMonthly,
  });

  List<ReportsData>? ordersToday;
  List<ReportsData>? ordersWeekly;
  List<ReportsData>? ordersMonthly;
  int? totalSalesToday;
  int? totalSalesWeekly;
  int? totalSalesMonthly;

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
    ordersToday: List<ReportsData>.from(json["OrdersToday"].map((x) =>  ReportsData.fromJson(x))),
    ordersWeekly: List<ReportsData>.from(json["OrdersWeekly"].map((x) => ReportsData.fromJson(x))),
    ordersMonthly: List<ReportsData>.from(json["OrdersMonthly"].map((x) =>  ReportsData.fromJson(x))),
    totalSalesToday: json["totalSalesToday"],
    totalSalesWeekly: json["totalSalesWeekly"],
    totalSalesMonthly: json["totalSalesMonthly"],
  );

  Map<String, dynamic> toJson() => {
    "OrdersToday": List<dynamic>.from(ordersToday!.map((x) => x)),
    "OrdersWeekly": List<dynamic>.from(ordersWeekly!.map((x) => x.toJson())),
    "OrdersMonthly": List<dynamic>.from(ordersMonthly!.map((x) => x)),
    "totalSalesToday": totalSalesToday,
    "totalSalesWeekly": totalSalesWeekly,
    "totalSalesMonthly": totalSalesMonthly,
  };
}

class ReportsData {
  ReportsData({
    this.id,
    this.orderCode,
    this.userCode,
    this.customerId,
    this.priceTotal,
    this.balance,
    this.discount,
    this.note,
    this.orderStatus,
    this.paymentStatus,
    this.qty,
    this.checkinCode,
    this.orderType,
    this.reasonsPartialDelivery,
    this.cancellationReason,
    this.deliveryDate,
    this.businessCode,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? orderCode;
  String? userCode;
  int? customerId;
  String? priceTotal;
  String? balance;
  dynamic discount;
  dynamic note;
  String? orderStatus;
  String? paymentStatus;
  int? qty;
  String? checkinCode;
  String? orderType;
  dynamic reasonsPartialDelivery;
  dynamic cancellationReason;
  DateTime? deliveryDate;
  String? businessCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ReportsData.fromJson(Map<String, dynamic> json) => ReportsData(
    id: json["id"],
    orderCode: json["order_code"],
    userCode: json["user_code"],
    customerId: json["customerID"],
    priceTotal: json["price_total"],
    balance: json["balance"],
    discount: json["discount"],
    note: json["note"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    qty: json["qty"],
    checkinCode: json["checkin_code"],
    orderType: json["order_type"],
    reasonsPartialDelivery: json["reasons_partial_delivery"],
    cancellationReason: json["cancellation_reason"],
    deliveryDate: DateTime.parse(json["delivery_date"]),
    businessCode: json["business_code"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_code": orderCode,
    "user_code": userCode,
    "customerID": customerId,
    "price_total": priceTotal,
    "balance": balance,
    "discount": discount,
    "note": note,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "qty": qty,
    "checkin_code": checkinCode,
    "order_type": orderType,
    "reasons_partial_delivery": reasonsPartialDelivery,
    "cancellation_reason": cancellationReason,
    "delivery_date": "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
    "business_code": businessCode,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
