// To parse this JSON data, do
//
//     final warehouseModel = warehouseModelFromJson(jsonString);
List<WarehouseModel> wareHousesFromJson(dynamic str) => List<WarehouseModel>.from(
  (str).map(
        (e) => WarehouseModel.fromJson(e),
  ),
);

class WarehouseModel {
  int? id;
  String? businessCode;
  String? warehouseCode;
  String? name;
  String? manager;
  int? regionId;
  int? subregionId;
  String? country;
  dynamic city;
  dynamic location;
  String? phoneNumber;
  String? email;
  dynamic longitude;
  dynamic latitude;
  String? status;
  dynamic isMain;
  String? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  WarehouseModel({
    this.id,
    this.businessCode,
    this.warehouseCode,
    this.name,
    this.manager,
    this.regionId,
    this.subregionId,
    this.country,
    this.city,
    this.location,
    this.phoneNumber,
    this.email,
    this.longitude,
    this.latitude,
    this.status,
    this.isMain,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
    id: json["id"],
    businessCode: json["business_code"],
    warehouseCode: json["warehouse_code"],
    name: json["name"],
    manager: json["manager"],
    regionId: json["region_id"],
    subregionId: json["subregion_id"],
    country: json["country"],
    city: json["city"],
    location: json["location"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    status: json["status"],
    isMain: json["is_main"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_code": businessCode,
    "warehouse_code": warehouseCode,
    "name": name,
    "manager": manager,
    "region_id": regionId,
    "subregion_id": subregionId,
    "country": country,
    "city": city,
    "location": location,
    "phone_number": phoneNumber,
    "email": email,
    "longitude": longitude,
    "latitude": latitude,
    "status": status,
    "is_main": isMain,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

