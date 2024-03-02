// To parse this JSON data, do
//
//     final surveyQuestions = surveyQuestionsFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'survey_questions_model.g.dart';

SurveyQuestions surveyQuestionsFromJson(String str) => SurveyQuestions.fromJson(json.decode(str));

String surveyQuestionsToJson(SurveyQuestions data) => json.encode(data.toJson());

class SurveyQuestions {
  SurveyQuestions({
    this.success,
    this.message,
    this.survey,
  });

  bool? success;
  String? message;
  List<SurveyQuestionsModel>? survey;

  bool? _success;
  String? _message;
  late List<SurveyQuestionsModel> _surveysQuestions;
  List<SurveyQuestionsModel> get surveysQuestions => _surveysQuestions;

  SurveyQuestions.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['Survey'] != null) {
      _surveysQuestions = <SurveyQuestionsModel>[];
      json['Survey'].forEach((v) {
        _surveysQuestions.add(SurveyQuestionsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "Survey": List<dynamic>.from(survey!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 12)
class SurveyQuestionsModel {
  SurveyQuestionsModel({
    this.id,
    this.surveyCode,
    this.questionCode,
    this.type,
    this.question,
    this.options,
    this.answer,
    this.image,
    this.position,
    this.points,
    this.time,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? surveyCode;
  @HiveField(3)
  String? questionCode;
  @HiveField(4)
  String? type;
  @HiveField(5)
  String? question;
  @HiveField(6)
  Options? options;
  @HiveField(7)
  String? answer;
  @HiveField(8)
  dynamic image;
  @HiveField(9)
  int? position;
  @HiveField(10)
  dynamic points;
  @HiveField(11)
  dynamic time;
  @HiveField(12)
  int? createdBy;
  @HiveField(13)
  dynamic updatedBy;
  @HiveField(14)
  DateTime? createdAt;
  @HiveField(15)
  DateTime? updatedAt;

  factory SurveyQuestionsModel.fromJson(Map<String, dynamic> json) => SurveyQuestionsModel(
    id: json["id"],
    surveyCode: json["survey_code"],
    questionCode: json["question_code"],
    type: json["type"]["name"],
    question: json["question"],
    options: json["options"] != null ?Options.fromJson(json["options"]) : null,
    answer: json["answer"] == null ? null : json["answer"],
    image: json["image"],
    position: json["position"],
    points: json["points"],
    time: json["time"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "survey_code": surveyCode,
    "question_code": questionCode,
    // "type": type.toJson(),
    "question": question,
    "options": options!.toJson(),
    "answer": answer == null ? null : answer,
    "image": image,
    "position": position,
    "points": points,
    "time": time,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class Options {
  Options({
    this.id,
    this.questionId,
    this.surveyCode,
    this.optionsA,
    this.optionsB,
    this.optionsC,
    this.optionsD,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? questionId;
  String? surveyCode;
  String? optionsA;
  String? optionsB;
  String? optionsC;
  String? optionsD;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    id: json["id"],
    questionId: json["questionID"],
    surveyCode: json["survey_code"] ?? null,
    optionsA: json["options_a"] ?? null,
    optionsB: json["options_b"] ?? null,
    optionsC: json["options_c"] ?? null,
    optionsD: json["options_d"] ?? null,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "questionID": questionId,
    "survey_code": surveyCode,
    "options_a": optionsA,
    "options_b": optionsB,
    "options_c": optionsC == null ? null : optionsC,
    "options_d": optionsD == null ? null : optionsD,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}


