import 'package:get/get.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:dio/dio.dart' as d;

class PaymentRepository{
  final ApiClient apiClient;

  PaymentRepository({ required this.apiClient});

  Future<d.Response> addOrderPayment(String orderID, String amount, String transactionID, String paymentMethod) async{
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.post(AppConstants.ADD_PAYMENT,data: {
      "orderID" : orderID,
      "amount": amount,
      "transactionID": transactionID,
      "paymentMethod": paymentMethod,
    });

    // return await apiClient.postData(AppConstants.ADD_PAYMENT, {
    //   "orderID" : orderID,
    //   "amount": amount,
    //   "transactionID": transactionID,
    //   "paymentMethod": paymentMethod,
    // });
    return response;
  }
}