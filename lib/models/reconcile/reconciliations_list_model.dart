import 'dart:convert';


List<ReconciliationListModel> reconciliationsListFromJson(dynamic str) => List<ReconciliationListModel>.from(
  (str).map(
        (e) => ReconciliationListModel.fromJson(e),
  ),
);
class ReconciliationListModel {
  int? id;
  String? reconciliationCode;
  String? cash;
  String? bank;
  String? cheque;
  String? mpesa;
  String? total;
  String? status;
  String? note;
  String? warehouseCode;
  String? warehouseName;
  String? reconciledTo;
  String? salesPerson;
  String? approvedBy;
  DateTime? approvedOn;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ReconciliationListProduct>? reconciliationProducts;

  ReconciliationListModel({
    this.id,
    this.reconciliationCode,
    this.cash,
    this.bank,
    this.cheque,
    this.mpesa,
    this.total,
    this.status,
    this.note,
    this.warehouseCode,
    this.warehouseName,
    this.reconciledTo,
    this.salesPerson,
    this.approvedBy,
    this.approvedOn,
    this.createdAt,
    this.updatedAt,
    this.reconciliationProducts,
  });

  factory ReconciliationListModel.fromRawJson(String str) => ReconciliationListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReconciliationListModel.fromJson(Map<String, dynamic> json) => ReconciliationListModel(
    id: json["id"],
    reconciliationCode: json["reconciliation_code"],
    cash: json["cash"],
    bank: json["bank"],
    cheque: json["cheque"],
    mpesa: json["mpesa"],
    total: json["total"],
    status: json["status"],
    note: json["note"],
    warehouseCode: json["warehouse_code"],
    warehouseName: json["warehouse"] == null?json["distributor"]["name"]:json["warehouse"]["name"],
    reconciledTo: json["reconciled_to"],
    salesPerson: json["sales_person"],
    approvedBy: json["approved_by"],
    approvedOn: json["approved_on"] == null ? null : DateTime.parse(json["approved_on"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    reconciliationProducts: json["reconciliation_products"] == null ? [] : List<ReconciliationListProduct>.from(json["reconciliation_products"]!.map((x) => ReconciliationListProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reconciliation_code": reconciliationCode,
    "cash": cash,
    "bank": bank,
    "cheque": cheque,
    "mpesa": mpesa,
    "total": total,
    "status": status,
    "note": note,
    "warehouse_code": warehouseCode,
    "reconciled_to": reconciledTo,
    "sales_person": salesPerson,
    "approved_by": approvedBy,
    "approved_on": approvedOn?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "reconciliation_products": reconciliationProducts == null ? [] : List<dynamic>.from(reconciliationProducts!.map((x) => x.toJson())),
  };
}

class ReconciliationListProduct {
  int? id;
  int? productId;
  String? productName;
  int? amount;
  String? userCode;
  String? reconciliationCode;
  String? warehouseCode;
  int? supplierId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReconciliationListProduct({
    this.id,
    this.productId,
    this.amount,
    this.userCode,
    this.reconciliationCode,
    this.warehouseCode,
    this.supplierId,
    this.productName,
    this.createdAt,
    this.updatedAt,
  });

  factory ReconciliationListProduct.fromRawJson(String str) => ReconciliationListProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReconciliationListProduct.fromJson(Map<String, dynamic> json) => ReconciliationListProduct(
    id: json["id"],
    productId: json["productID"],
    productName: json["product_information"][0]["product_name"],
    amount: json["amount"],
    userCode: json["userCode"],
    reconciliationCode: json["reconciliation_code"],
    warehouseCode: json["warehouse_code"],
    supplierId: json["supplierID"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productID": productId,
    "amount": amount,
    "userCode": userCode,
    "reconciliation_code": reconciliationCode,
    "warehouse_code": warehouseCode,
    "supplierID": supplierId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
