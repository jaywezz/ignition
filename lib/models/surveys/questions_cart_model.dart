

import 'package:soko_flow/models/surveys/survey_questions_model.dart';

class QuestionResponses {
  QuestionResponses({
    this.surveyQuestionsModel,
    this.answer,
    this.customer_id,
    this.reason
  });

  SurveyQuestionsModel? surveyQuestionsModel;
  String? customer_id;
  String? answer;
  String? reason;

  Map<String, dynamic> toJson() => {
    "question_code": surveyQuestionsModel!.questionCode,
    "survey_code": surveyQuestionsModel!.surveyCode,
    "customer_id":customer_id,
    "answer": answer,
    "reason": reason
  };

}

