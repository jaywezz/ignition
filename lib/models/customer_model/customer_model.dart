import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'customer_model.g.dart';

CustomerModel customerModelFromJson(dynamic str) =>
    CustomerModel.fromJson(str);

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    this.message,
    this.success,
    this.data,
  });

  bool? success;
  String? message;
  List<CustomerDataModel>? data;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        success: json["success"],
        message: json["message"],
        data: List<CustomerDataModel>.from(
            json["data"].map((x) => CustomerDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 0)
class CustomerDataModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? customerName;
  @HiveField(2)
  String? account;
  @HiveField(3)
  String? manufacturerNumber;
  @HiveField(4)
  String? vatNumber;
  @HiveField(5)
  String? approval;
  @HiveField(6)
  String? deliveryTime;
  @HiveField(7)
  String? address;
  @HiveField(8)
  String? city;
  @HiveField(9)
  String? province;
  @HiveField(10)
  String? postalCode;
  @HiveField(11)
  String? country;
  @HiveField(12)
  String? latitude;
  @HiveField(13)
  String? longitude;
  @HiveField(14)
  String? contactPerson;
  @HiveField(15)
  String? telephone;
  @HiveField(16)
  String? customerGroup;
  @HiveField(17)
  String? customerSecondaryGroup;
  @HiveField(18)
  String? priceGroup;
  @HiveField(19)
  String? route;
  @HiveField(20)
  String? branch;
  @HiveField(21)
  String? status;
  @HiveField(22)
  String? email;
  @HiveField(23)
  String? phoneNumber;
  @HiveField(24)
  String? businessCode;
  @HiveField(25)
  String? createdBy;
  @HiveField(26)
  String? updatedBy;
  @HiveField(27)
  String? createdAt;
  @HiveField(28)
  String? updatedAt;
  @HiveField(29)
  String? image;
  @HiveField(30)
  String? creditorStatus;

  CustomerDataModel(
      {this.id,
      this.customerName,
      this.account,
      this.manufacturerNumber,
      this.vatNumber,
      this.approval,
      this.deliveryTime,
      this.address,
      this.city,
      this.province,
      this.postalCode,
      this.country,
      this.latitude,
      this.longitude,
      this.contactPerson,
      this.telephone,
      this.customerGroup,
      this.customerSecondaryGroup,
      this.priceGroup,
      this.route,
      this.branch,
      this.status,
      this.email,
      this.phoneNumber,
      this.businessCode,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
        this.image,
        this.creditorStatus
      });

  factory CustomerDataModel.fromJson(Map<String, dynamic> json) =>
      CustomerDataModel(
        id: json['id'],
        customerName: json['customer_name'],
        account: json['account'],
        manufacturerNumber: json['manufacturer_number'],
        vatNumber: json['vat_number'],
        approval: json['approval'],
        deliveryTime: json['delivery_time'],
        address: json['address'],
        city: json['city'],
        province: json['province'],
        postalCode: json['postal_code'],
        country: json['country'],
        latitude: json['latitude'] ?? "0.0",
        longitude: json['longitude'] ?? "0.0",
        contactPerson: json['contact_person'],
        telephone: json['telephone'],
        customerGroup: json['customer_group'],
        customerSecondaryGroup: json['customer_secondary_group'],
        priceGroup: json['price_group'],
        route: json['route'],
        branch: json['branch'],
        status: json['status'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        businessCode: json['business_code'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        image: json["image"],
        creditorStatus: json["is_creditor"].toString()
      );

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'customer_name': this.customerName,
        'account': this.account,
        'manufacturer_number': this.manufacturerNumber,
        'vat_number': this.vatNumber,
        'approval': this.approval,
        'delivery_time': this.deliveryTime,
        'address': this.address,
        'city': this.city,
        'province': this.province,
        'postal_code': this.postalCode,
        'country': this.country,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'contact_person': this.contactPerson,
        'telephone': this.telephone,
        'customer_group': this.customerGroup,
        'customer_secondary_group': this.customerSecondaryGroup,
        'price_group': this.priceGroup,
        'route': this.route,
        'branch': this.branch,
        'status': this.status,
        'email': this.email,
        'phone_number': this.phoneNumber,
        'business_code': this.businessCode,
        'created_by': this.createdBy,
        'updated_by': this.updatedBy,
        'created_at': this.createdAt,
        'updated_at': this.updatedAt,
      };
}

enum Status { RUNNING, ENDED, TO_BE_DETERMINED }

final statusValues = EnumValues({
  "Ended": Status.ENDED,
  "Running": Status.RUNNING,
  "To Be Determined": Status.TO_BE_DETERMINED
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
