import 'package:get/get_connect/http/src/response/response.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';

import '../api_service/api-service.dart';
import 'package:dio/dio.dart' as d;

class SurveyRepository {
  final ApiClient apiClient;
  SurveyRepository({required this.apiClient});

  Future<d.Response> getSurveys() async{
    String SURVEYS =
        '/survey';
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.post(SURVEYS);
    return response;
  }

  Future<d.Response> getSurveysQuestions(String survey_id) async{
    String SURVEYS =
        '/survey/questions/${survey_id}';
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.get(SURVEYS);
    return response;
  }

  Future<d.Response> submitResponse(String cartData, String survey_id) async{
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    String SURVEYS_RESPONSE =
        '/survey/responses';
    final d.Response response = await dio.post(SURVEYS_RESPONSE,data: cartData);

    return response;
  }
}
