import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/repository/survey_repo.dart';
import 'package:soko_flow/models/response_model.dart';
import 'package:soko_flow/models/surveys/questions_cart_model.dart';
import 'package:soko_flow/models/surveys/survey_questions_model.dart';
import 'package:soko_flow/models/surveys/surveys.dart';

import '../data/hive_database/hive_constants.dart';
import 'package:dio/dio.dart' as d;


class SurveyController extends GetxController{
   SurveyRepository surveyRepository;
   SurveyController({required this.surveyRepository});
   static final Logger _log = Logger(
     printer: PrettyPrinter(),
   );

   List<SurveyModel> lstSurveys = List<SurveyModel>.empty(growable: true).obs;
   List<SurveyQuestionsModel> lstSurveysQuestions = List<SurveyQuestionsModel>.empty(growable: true).obs;

   List<QuestionResponses> _responseList = [];
   List<QuestionResponses> get responseList => _responseList;

   var isDataProcessing = false.obs;
   bool _isLoading = false;
   bool get isLoading => _isLoading;

   @override
  void onInit() {
    // TODO: implement onInit
    getSurveys();
    super.onInit();
  }

   getSurveys() async {
     if(!Hive.isAdapterRegistered(11)){
       Hive.registerAdapter(SurveyModelAdapter());
     }
     _isLoading = true;

     lstSurveys.clear();
     try {
       await surveyRepository.getSurveys().then(
               (resp) {
             lstSurveys.addAll(Surveys
                 .fromJson(resp.data)
                 .surveys.reversed);
             _log.i(resp.data);
             HiveDataManager(HiveBoxConstants.surveysDb).addHiveData(lstSurveys);
           }, onError: (err) async{
               if(err.toString().contains("SocketException") || err.toString().contains("TimeoutException")) {
                 await HiveDataManager(HiveBoxConstants.surveysDb)
                     .getHiveData()
                     .then((box) {
                   lstSurveys.addAll(
                       box.get(HiveBoxConstants.surveysDb).cast<SurveyModel>());
                 });

                 _isLoading = false;
                 isDataProcessing(false);
                 print("latest allocations offline: $lstSurveys");
                 update();
               }else{
                 showCustomSnackBar("Error occurred getting surveys", isError: true);
               }

         // showSnackBar('Error', err.toString(), Colors.red);
       });
       _isLoading = false;
       update();
     } catch (exception) {
       _isLoading = false;
       update();
       showCustomSnackBar("An error occurred. Try again later", isError: true);;
     }
   }

   getSurveysQuestions(String survey_id) async {
     if(!Hive.isAdapterRegistered(12)){
       Hive.registerAdapter(SurveyQuestionsModelAdapter());
     }
     _isLoading = true;

     lstSurveysQuestions.clear();
     try {
       await surveyRepository.getSurveysQuestions(survey_id).then(
               (resp) {
             lstSurveysQuestions.addAll(SurveyQuestions
                 .fromJson(resp.data).surveysQuestions);
             _log.i(resp.data);
             HiveDataManager(HiveBoxConstants.surveyQuestionsDB).addHiveData(lstSurveysQuestions);
           }, onError: (err) async{
         if(err.toString().contains("SocketException") || err.toString().contains("TimeoutException")) {
           await HiveDataManager(HiveBoxConstants.surveyQuestionsDB)
               .getHiveData()
               .then((box) {
             lstSurveys.addAll(
                 box.get(HiveBoxConstants.surveyQuestionsDB).cast<SurveyQuestionsModel>());
           });

           _isLoading = false;
           isDataProcessing(false);
           print("latest allocations offline: $lstSurveys");
           update();
         }else{
           showCustomSnackBar("Error occurred getting surveys", isError: true);
         }

         // showSnackBar('Error', err.toString(), Colors.red);
       });
       _isLoading = false;
       update();
     } catch (exception) {
       _isLoading = false;
       print("exception: $exception");
       update();
       showCustomSnackBar(exception.toString(), isError: true);;
     }
   }

   Future<d.Response> surveyResponse(String survey_id) async {
     _isLoading = true;
     // print("cart data ${_cartData}");
     update();
     String jsonCart = jsonEncode(_responseList);
     print(jsonCart);

     print("json cart at the controller ${jsonCart}");
     d.Response response = await surveyRepository.submitResponse(jsonCart, survey_id);
     late ResponseModel responseModel;
     if (response.statusCode == 200) {
       showCustomSnackBar("Successfully submitted response", isError: false);

       _isLoading = false;
       update();
       Get.back();
       responseModel = ResponseModel(true, response.data["Message"]);
     }
     else {

       showCustomSnackBar("An error occurred", isError: false);
       _isLoading = false;
       print(response.data);
       update();
       responseModel = ResponseModel(false, response.data["message"]);
     }
     _isLoading = false;
     _responseList.clear();
     update();
     return response;
   }


   addQuestionList(QuestionResponses questionResponses){

     if(_responseList.map((question) => question.surveyQuestionsModel!.id).contains(questionResponses.surveyQuestionsModel!.id)){
       // print(_cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId));
       int index = _responseList.indexWhere((element) =>element.surveyQuestionsModel!.id == questionResponses.surveyQuestionsModel!.id);
       print(index);
       _responseList[index].answer = questionResponses.answer;
       update();
       print("New lst responses ${_responseList}");
     }else{
       print("false");
       _responseList.add(questionResponses);
     }
     update();
     print("New lst responses ${_responseList}");
   }

}