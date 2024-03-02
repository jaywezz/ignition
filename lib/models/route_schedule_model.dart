// To parse this JSON data, do
//
//     final routeSchedule = routeScheduleFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/adapters.dart';

part 'route_schedule_model.g.dart';

// UserRouteModel routeScheduleFromJson(String str) => UserRouteModel.fromJson(json.decode(str));
List<UserRouteModel> routesFromJson(dynamic str) => List<UserRouteModel>.from(
  (str).map(
        (e) => UserRouteModel.fromJson(e),
  ),
);
// String routeScheduleToJson(RouteSchedule data) => json.encode(data.toJson());

@HiveType(typeId: 19)
class UserRouteModel {
  UserRouteModel({
    this.name,
    this.routeCode,
    this.status,
    this.startDate,
    this.endDate,
    this.customerName,
    this.account,
    this.routeType,
    this.address,
    this.email,
    this.telephone,
    this.latitude,
    this.longitude,
    // this.isOffline
  });

  @HiveField(0)
  String? name;
  @HiveField(1)
  String? routeCode;
  @HiveField(2)
  String? status;
  @HiveField(3)
  DateTime? startDate;
  @HiveField(4)
  DateTime? endDate;
  @HiveField(5)
  String? customerName;
  @HiveField(6)
  int? account;
  @HiveField(7)
  String? routeType;
  @HiveField(8)
  String? address;
  @HiveField(9)
  String? email;
  @HiveField(10)
  String? telephone;
  @HiveField(11)
  String? latitude;
  @HiveField(12)
  String? longitude;
  // @HiveField(13)@Default(false)
  // bool? isOffline;


  factory UserRouteModel.fromJson(Map<String, dynamic> json) => UserRouteModel(
    name: json["name"],
    routeCode: json["route_code"],
    status: json["status"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    customerName: json["customer_name"] ?? "",
    account: json["customer_id"] ?? null ,
    routeType: json["Type"] ?? "" ,
    address: json["address"] ?? "",
    email: json["email"] ?? "",
    telephone: json["phone_number"] ?? "",
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "route_code": routeCode,
    "status": status,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "customer_name": customerName,
  };
}

enum ScheduleTypes {Individual, Assigned, Routes, all}

