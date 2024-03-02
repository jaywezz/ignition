// import 'dart:convert';
//
// CustomerOrdersModels customerOrdersModelsFromJson(String str) =>
//     CustomerOrdersModels.fromJson(json.decode(str));
//
// String customerOrdersModelsToJson(CustomerOrdersModels data) =>
//     json.encode(data.toJson());
//
// class CustomerOrdersModels {
//   CustomerOrdersModels({
//     this.success,
//     this.status,
//     this.message,
//     this.orders,
//   });
//
//   bool? success;
//   int? status;
//   String? message;
//   List<Order>? orders;
//
//   factory CustomerOrdersModels.fromJson(Map<String, dynamic> json) =>
//       CustomerOrdersModels(
//         success: json["success"],
//         status: json["status"],
//         message: json["message"],
//         orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "status": status,
//         "message": message,
//         "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
//       };
// }
//
// class Order {
//   Order({
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
//   String? discount;
//   String? note;
//   String? orderStatus;
//   String? paymentStatus;
//   int? qty;
//   String? checkinCode;
//   String? orderType;
//   String? reasonsPartialDelivery;
//   String? cancellationReason;
//   String? deliveryDate;
//   String? businessCode;
//   String? createdAt;
//   String? updatedAt;
//
//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"],
//         orderCode: json["order_code"],
//         userCode: json["user_code"],
//         customerId: json["customerID"],
//         priceTotal: json["price_total"],
//         balance: json["balance"],
//         discount: json["discount"],
//         note: json["note"],
//         orderStatus: json["order_status"],
//         paymentStatus: json["payment_status"],
//         qty: json["qty"],
//         checkinCode: json["checkin_code"],
//         orderType: json["order_type"],
//         reasonsPartialDelivery: json["reasons_partial_delivery"],
//         cancellationReason: json["cancellation_reason"],
//         deliveryDate: json["delivery_date"],
//         businessCode: json["business_code"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "order_code": orderCode,
//         "user_code": userCode,
//         "customerID": customerId,
//         "price_total": priceTotal,
//         "balance": balance,
//         "discount": discount,
//         "note": note,
//         "order_status": orderStatus,
//         "payment_status": paymentStatus,
//         "qty": qty,
//         "checkin_code": checkinCode,
//         "order_type": orderType,
//         "reasons_partial_delivery": reasonsPartialDelivery,
//         "cancellation_reason": cancellationReason,
//         "delivery_date": deliveryDate,
//         "business_code": businessCode,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }
