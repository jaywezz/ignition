// To parse this JSON data, do
//
//     final surveys = surveysFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'surveys.g.dart';


Surveys surveysFromJson(String str) => Surveys.fromJson(json.decode(str));

String surveysToJson(Surveys data) => json.encode(data.toJson());

class Surveys {
  Surveys({
    this.success,
    this.message,
    this.survey,
  });

  bool? success;
  String? message;
  List<SurveyModel>? survey;

  bool? _success;
  String? _message;
  late List<SurveyModel> _surveys;
  List<SurveyModel> get surveys => _surveys;

  Surveys.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['Survey'] != null) {
      _surveys = <SurveyModel>[];
      json['Survey'].forEach((v) {
        _surveys.add(SurveyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "Survey": List<dynamic>.from(survey!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 11)
class SurveyModel {
  SurveyModel({
    this.id,
    this.businessCode,
    this.code,
    this.title,
    this.description,
    this.category,
    this.status,
    this.startDate,
    this.endDate,
    this.type,
    this.visibility,
    this.image,
    this.correctAnswers,
    this.wrongAnswers,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  dynamic businessCode;
  @HiveField(2)
  String? code;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? description;
  @HiveField(5)
  int? category;
  @HiveField(6)
  String? status;
  @HiveField(7)
  DateTime? startDate;
  @HiveField(8)
  DateTime? endDate;
  @HiveField(9)
  String? type;
  @HiveField(10)
  String? visibility;
  @HiveField(11)
  dynamic image;
  @HiveField(12)
  int? correctAnswers;
  @HiveField(13)
  int? wrongAnswers;
  @HiveField(14)
  int? createdBy;
  @HiveField(15)
  dynamic updatedBy;
  @HiveField(16)
  DateTime? createdAt;
  @HiveField(17)
  DateTime? updatedAt;


  factory SurveyModel.fromJson(Map<String, dynamic> json) => SurveyModel(
    id: json["id"],
    businessCode: json["business_code"],
    code: json["code"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    status: json["status"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    type: json["type"],
    visibility: json["visibility"],
    image: json["image"],
    correctAnswers: json["correct_answers"],
    wrongAnswers: json["wrong_answers"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_code": businessCode,
    "code": code,
    "title": title,
    "description": description,
    "category": category,
    "status": status,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "type": type,
    "visibility": visibility,
    "image": image,
    "correct_answers": correctAnswers,
    "wrong_answers": wrongAnswers,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
