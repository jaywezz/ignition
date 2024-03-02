// To parse this JSON data, do
//
//     final distributors = distributorsFromMap(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';

List<DistributorsModel> distributorsJson(dynamic str) => List<DistributorsModel>.from(
  (str).map(
        (e) => DistributorsModel.fromMap(e),
  ),
);
String distributorsToMap(Distributors data) => json.encode(data.toMap());

class Distributors {
  Distributors({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<DistributorsModel>? data;

  bool? _success;
  String? _message;
  late List<DistributorsModel> _distributors;
  List<DistributorsModel> get distributorsList => _distributors;

  Distributors.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['Data'] != null) {
      _distributors = <DistributorsModel>[

      ];
      json['Data'].forEach((v) {
        _distributors.add(DistributorsModel.fromMap(v));
      });
    }
  }
  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "Data": List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}
// @HiveType(typeId: 21)
class DistributorsModel {
  DistributorsModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.telephone,
    this.businessCode,
  });

  // @Hive
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? telephone;
  String? businessCode;

  factory DistributorsModel.fromMap(Map<String, dynamic> json) => DistributorsModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    telephone: json["telephone"],
    businessCode: json["business_code"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "telephone": telephone,
    "business_code": businessCode,
  };
}


