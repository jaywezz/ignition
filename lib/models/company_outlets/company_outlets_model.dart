// To parse this JSON data, do
//
//     final companyRoutesModel = companyRoutesModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'company_outlets_model.g.dart';

List<CompanyOutletsModel> companyOutletsFromJson(dynamic str) => List<CompanyOutletsModel>.from(
  (str).map(
        (e) => CompanyOutletsModel.fromJson(e),
  ),
);
// String companyRoutesModelToJson(CompanyRoutesModel? data) => json.encode(data!.toJson());

@HiveType(typeId: 13)
class CompanyOutletsModel {
  CompanyOutletsModel({
    this.id,
    this.outletCode,
    this.businessCode,
    this.outletName,
    this.createdAt,
    this.updatedAt,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? outletCode;
  @HiveField(2)
  String? businessCode;
  @HiveField(3)
  String? outletName;
  @HiveField(4)
  DateTime? createdAt;
  @HiveField(5)
  DateTime? updatedAt;

  factory CompanyOutletsModel.fromJson(Map<String, dynamic> json) => CompanyOutletsModel(
    id: json["id"],
    outletCode: json["outlet_code"],
    businessCode: json["business_code"],
    outletName: json["outlet_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "outlet_code": outletCode,
    "business_code": businessCode,
    "outlet_name": outletName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
