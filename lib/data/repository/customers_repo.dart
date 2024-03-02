import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/services/auth_service.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../api_service/api-service.dart';
d.Dio dio = d.Dio(
  d.BaseOptions(
    headers: {
      "Authorization": AuthService.instance.authUser == null
          ? ''
          : 'Bearer ${AuthService.instance.authUser!.accessToken}',
    },
    // baseUrl: "http://172.104.245.14/sokoflowadmin/api/",
    baseUrl: AppConstants.BASE_URL,

    connectTimeout: 150000,
    receiveTimeout: 150000,
    responseType: d.ResponseType.json,
  ),
);


class CustomerRepository {
  final ApiClient apiClient;
  CustomerRepository({required this.apiClient});



  Future<CustomerModel> getCustomers(String businessCode, var pageSize) async {

    try{
      print("repo getting customers");
      dio.interceptors.add(
        d.LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
      final d.Response response = await dio.get('/customers/$businessCode?page_size=$pageSize');
      // Response response =
      //     await apiClient.getData('/customers/$businessCode?page_size=$pageSize');
      print("got customers: ${response.data}");


      return customerModelFromJson(response.data);
    }on d.DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e,s){
      print("error on repo ${s}");
      throw e;
    }
  }
}
