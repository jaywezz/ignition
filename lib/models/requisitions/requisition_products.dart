
import 'dart:convert';

List< RequisitionModel> requisitionsFromJson(dynamic str) => List<RequisitionModel>.from(
  (str).map(
        (e) => RequisitionModel.fromJson(e),
  ),
);
class RequisitionModel {
  String? id;
  String? status;
  DateTime? date;
  List< RequisitionProducts>? data;

  RequisitionModel({
    this.id,
    this.status,
    this.date,
    this.data,
  });

  factory RequisitionModel.fromJson(Map<String, dynamic> json) => RequisitionModel(
    id: json["requisition_id"].toString(),
    status: json["status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    data: json["data"] == null ? [] : List< RequisitionProducts>.from(json["data"]!.map((x) =>  RequisitionProducts.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "date": date?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class RequisitionProducts {
  int? id;
  int? productId;
  int? requisitionId;
  int? quantity;
  int? stockRequisitionId;
  int? productInformationId;
  bool? approved;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? productName;

  RequisitionProducts({
    this.id,
    this.productId,
    this.requisitionId,
    this.quantity,
    this.stockRequisitionId,
    this.productInformationId,
    this.approved,
    this.createdAt,
    this.updatedAt,
    this.productName,
  });

  factory  RequisitionProducts.fromJson(Map<String, dynamic> json) =>  RequisitionProducts(
    id: json["id"],
    productId: json["product_id"],
    requisitionId: json["requisition_id"],
    quantity: json["quantity"],
    stockRequisitionId: json["stock_requisition_id"],
    productInformationId: json["product_information_id"],
    approved: json["approved"] == 1? true: false,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    productName: json["product_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "requisition_id": requisitionId,
    "quantity": quantity,
    "stock_requisition_id": stockRequisitionId,
    "product_information_id": productInformationId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product_name": productName,
  };
}



