import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';
import 'package:dio/dio.dart' as d;

class ReconcileRepo {
  final ApiClient apiClient;

  ReconcileRepo({required this.apiClient});


  Future<d.Response> getDistributors() async{
    String DISTRIBUTORS ='/distributors';
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.get(DISTRIBUTORS);
    // return await apiClient.getData(DISTRIBUTORS);
    return response;
  }

  Future<d.Response> getWarehouses() async{
    String DISTRIBUTORS ='/get/warehouses';
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.get(DISTRIBUTORS);
    return response;
  }


  Future<d.Response> getReconcileCash() async{
    String CASH_RECONCILE ='/reconcile/payment';
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    final d.Response response = await dio.get(CASH_RECONCILE);
    // return await apiClient.getData(CASH_RECONCILE);
    return response;
  }

  Future<d.Response> reconcileStock(var data, String wareHouseCode, String distributorId) async{
   try{
     print("warehouse code: ${wareHouseCode}");
     String RECONCILE ='/reconcile/products/${wareHouseCode}/$distributorId';
     dio.interceptors.add(
       d.LogInterceptor(
         request: true,
         requestBody: true,
         requestHeader: true,
         responseHeader: true,
         responseBody: true,
       ),
     );
     print("here again");
     final d.Response response = await dio.post(RECONCILE,data: data);
     // return await apiClient.postData(RECONCILE, data);
     return response;
   }catch(e){
     throw e;
   }
  }
}