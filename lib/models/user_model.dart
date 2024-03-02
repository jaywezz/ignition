// import 'dart:convert';

// UserModel userFromJson(String str) => UserModel.toObject(json.decode(str));

// class UserModel {
//   String token;
//   UserModel({required this.token});

//   factory UserModel.toObject(Map<String, dynamic> json) => UserModel(
//         token: json['access_token'],
//       );

//   Map<String, dynamic> toJson() => {
//         "access_token": token,
//       };
// }

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.success,
    this.tokenType,
    this.message,
    this.accessToken,
    this.user,
  });

  bool? success;
  String? tokenType;
  String? message;
  String? accessToken;
  User? user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        tokenType: json["token_type"],
        message: json["message"],
        accessToken: json["access_token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token_type": tokenType,
        "message": message,
        "access_token": accessToken,
        "user": user!.toJson(),
      };
}

class User {
  User({
    this.id,
    this.userCode,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.businessCode,
    this.phoneNumber,
    this.location,
    this.gender,
    this.accountType,
    this.status,
    this.adminId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? userCode;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? businessCode;
  String? phoneNumber;
  String? location;
  String? gender;
  String? accountType;
  String? status;
  String? adminId;
  String? createdAt;
  String? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userCode: json["user_code"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        businessCode: json["business_code"],
        phoneNumber: json["phone_number"],
        location: json["location"],
        gender: json["gender"],
        accountType: json["account_type"],
        status: json["status"],
        adminId: json["admin_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_code": userCode,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "business_code": businessCode,
        "phone_number": phoneNumber,
        "location": location ?? "",
        "gender": gender ?? "",
        "account_type": accountType,
        "status": status,
        "admin_id": adminId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
