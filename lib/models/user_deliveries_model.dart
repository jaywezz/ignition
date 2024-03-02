// // To parse this JSON data, do
// //
// //     final userDeliveriesModel = userDeliveriesModelFromJson(jsonString);

// import 'dart:convert';

// import 'package:soko_flow/database/models/products_by_category_model.dart';

// UserDeliveriesModel userDeliveriesModelFromJson(String str) =>
//     UserDeliveriesModel.fromJson(json.decode(str));

// String userDeliveriesModelToJson(UserDeliveriesModel data) =>
//     json.encode(data.toJson());

// class UserDeliveriesModel {
//   UserDeliveriesModel({
//     this.success,
//     this.message,
//     this.data,
//   });

//   bool? success;
//   String? message;
//   List<Delivery>? data;

//   factory UserDeliveriesModel.fromJson(Map<String, dynamic> json) =>
//       UserDeliveriesModel(
//         success: json["success"],
//         message: json["message"],
//         data:
//             List<Delivery>.from(json["data"].map((x) => Delivery.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class Delivery {
//   Delivery({
//     this.customerName,
//     this.name,
//     this.deliveryDate,
//     this.deliveryStatus,
//     this.orderCode,
//     this.deliveryCode,
//   });

//   String? customerName;
//   String? name;
//   String? deliveryDate;
//   String? deliveryStatus;
//   String? orderCode;
//   String? deliveryCode;

//   factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
//         customerName: json["customer_name"],
//         name: json["name"],
//         deliveryDate: json["delivery_date"],
//         deliveryStatus: json["delivery_status"],
//         orderCode: json["order_code"],
//         deliveryCode: json["delivery_code"],
//       );

//   Map<String, dynamic> toJson() => {
//         "customer_name": customerName,
//         "name": name,
//         "delivery_date": deliveryDate,
//         "delivery_status": deliveryStatus,
//         "order_code": orderCode,
//         "delivery_code": deliveryCode,
//       };
// }
