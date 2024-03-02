// To parse this JSON data, do
//
//     final companyRoutesModel = companyRoutesModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'company_routes_model.g.dart';

List<Subregion> companyRoutesFromJson(dynamic str) => List<Subregion>.from(
  (str).map(
        (e) => Subregion.fromJson(e),
  ),
);
@HiveType(typeId: 14)
class Subregion {
  Subregion({
    this.id,
    this.regionId,
    this.name,
    this.primaryKey,
    this.createdAt,
    this.updatedAt,
    this.area,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  int? regionId;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? primaryKey;
  @HiveField(4)
  DateTime? createdAt;
  @HiveField(5)
  DateTime? updatedAt;
  @HiveField(6)
  List<RegionalRoutes>? area;

  factory Subregion.fromJson(Map<String, dynamic> json) => Subregion(
    id: json["id"],
    regionId: json["region_id"],
    name: json["name"],
    primaryKey: json["primary_key"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    area: json["area"] == null ? [] : List<RegionalRoutes>.from(json["area"]!.map((x) => RegionalRoutes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "region_id": regionId,
    "name": name,
    "primary_key": primaryKey,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "area": area == null ? [] : List<dynamic>.from(area!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 15)
class RegionalRoutes {
  RegionalRoutes({
    this.id,
    this.name,
    this.primaryKey,
    this.createdAt,
    this.updatedAt,
    this.subregion,
    this.subregionId,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? primaryKey;
  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  DateTime? updatedAt;
  @HiveField(5)
  List<Subregion>? subregion;
  @HiveField(6)
  int? subregionId;

  factory RegionalRoutes.fromJson(Map<String, dynamic> json) => RegionalRoutes(
    id: json["id"],
    name: json["name"],
    primaryKey: json["primary_key"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    subregion: json["subregion"] == null ? [] : List<Subregion>.from(json["subregion"]!.map((x) => Subregion.fromJson(x))),
    subregionId: json["subregion_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "primary_key": primaryKey,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "subregion": subregion == null ? [] : List<dynamic>.from(subregion!.map((x) => x.toJson())),
    "subregion_id": subregionId,
  };
}



