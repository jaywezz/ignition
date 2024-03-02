
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';
import 'package:dio/dio.dart' as d;

class OrderRepository {
  final ApiClient apiClient;
  OrderRepository({required this.apiClient});

  // get tv show

  Future<d.Response> getOrderDetails(String orderCode) async{
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );

    String ORDER_DETAILS ='/customers/order/$orderCode/details';
    final d.Response response = await dio.get(ORDER_DETAILS);
    debugPrint("the ordercode: $orderCode");
    return response;
  }

  Future<d.Response> getPreOrders(String customer_id) async{
    print("customer id: $customer_id");
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    String STOCK_HISTORY ='/SalesHistory/newsale/${customer_id}';
    final d.Response response = await dio.get(STOCK_HISTORY);
    return response;
  }


  Future<d.Response> getUserOrders() async{
    try{
      String STOCK_HISTORY ='/checkin/userOrders';
      dio.interceptors.add(
        d.LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
      final d.Response response = await dio.get(STOCK_HISTORY);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<d.Response> getVanOrders(String customer_id) async{
    String STOCK_HISTORY ='/SalesHistory/vansale/${customer_id}';
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.get(STOCK_HISTORY);

    return response;
  }

}
