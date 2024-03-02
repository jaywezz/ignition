// To parse this JSON data, do
//
//     final companyRoutesModel = companyRoutesModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'customer_groups.g.dart';

List<CustomerGroupModel> customerGroupsFromJson(dynamic str) =>
    List<CustomerGroupModel>.from(
      (str).map(
        (e) => CustomerGroupModel.fromJson(e),
      ),
    );
// String companyRoutesModelToJson(CompanyRoutesModel? data) => json.encode(data!.toJson());

@HiveType(typeId: 22)
class CustomerGroupModel {
  CustomerGroupModel({
    this.id,
    this.groupName,
    this.businessCode,
    this.createdAt,
    this.updatedAt,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? groupName;
  @HiveField(2)
  String? businessCode;

  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  DateTime? updatedAt;

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) =>
      CustomerGroupModel(
        id: json["id"],
        groupName: json["group_name"],
        businessCode: json["business_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "business_code": businessCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
