// // To parse this JSON data, do
// //
// //     final customerDeliveriesModels = customerDeliveriesModelsFromJson(jsonString);
//
// import 'dart:convert';
//
// CustomerDeliveriesModels customerDeliveriesModelsFromJson(String str) =>
//     CustomerDeliveriesModels.fromJson(json.decode(str));
//
// String customerDeliveriesModelsToJson(CustomerDeliveriesModels data) =>
//     json.encode(data.toJson());
//
// class CustomerDeliveriesModels {
//   CustomerDeliveriesModels({
//     this.success,
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   bool? success;
//   int? status;
//   String? message;
//   List<ReceiveStockModel>? data;
//
//   factory CustomerDeliveriesModels.fromJson(Map<String, dynamic> json) =>
//       CustomerDeliveriesModels(
//         success: json["success"],
//         status: json["status"],
//         message: json["message"],
//         data: List<ReceiveStockModel>.from(json["data"].map((x) => ReceiveStockModel.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "status": status,
//         "message": message,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class ReceiveStockModel {
//   ReceiveStockModel({
//     this.id,
//     this.businessCode,
//     this.deliveryCode,
//     this.orderCode,
//     this.allocated,
//     this.deliveryNote,
//     this.deliveryStatus,
//     this.customer,
//     this.deliveredTime,
//     this.acceptAllocation,
//     this.customerConfirmation,
//     this.createdBy,
//     this.updatedBy,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? businessCode;
//   String? deliveryCode;
//   String? orderCode;
//   String? allocated;
//   String? deliveryNote;
//   String? deliveryStatus;
//   String? customer;
//   String? deliveredTime;
//   String? acceptAllocation;
//   String? customerConfirmation;
//   String? createdBy;
//   String? updatedBy;
//   String? createdAt;
//   String? updatedAt;
//
//   factory ReceiveStockModel.fromJson(Map<String, dynamic> json) => ReceiveStockModel(
//         id: json["id"],
//         businessCode: json["business_code"],
//         deliveryCode: json["delivery_code"],
//         orderCode: json["order_code"],
//         allocated: json["allocated"],
//         deliveryNote: json["delivery_note"],
//         deliveryStatus: json["delivery_status"],
//         customer: json["customer"],
//         deliveredTime: json["delivered_time"],
//         acceptAllocation: json["accept_allocation"],
//         customerConfirmation: json["customer_confirmation"],
//         createdBy: json["created_by"],
//         updatedBy: json["updated_by"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "business_code": businessCode,
//         "delivery_code": deliveryCode,
//         "order_code": orderCode,
//         "allocated": allocated,
//         "delivery_note": deliveryNote,
//         "delivery_status": deliveryStatus,
//         "customer": customer,
//         "delivered_time": deliveredTime,
//         "accept_allocation": acceptAllocation,
//         "customer_confirmation": customerConfirmation,
//         "created_by": createdBy,
//         "updated_by": updatedBy,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }
