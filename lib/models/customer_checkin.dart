import 'dart:convert';

CustomerCheckinModel customerCheckinModelFromJson(String str) =>
    CustomerCheckinModel.fromJson(json.decode(str));

String customerCheckinModelToJson(CustomerCheckinModel data) =>
    json.encode(data.toJson());

class CustomerCheckinModel {
  CustomerCheckinModel({
    this.success,
    this.message,
    this.checkingCode,
  });

  bool? success;
  String? message;
  String? checkingCode;

  factory CustomerCheckinModel.fromJson(Map<String, dynamic> json) =>
      CustomerCheckinModel(
        success: json["success"],
        message: json["message"],
        checkingCode: json["checking Code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "checking Code": checkingCode,
      };
}
