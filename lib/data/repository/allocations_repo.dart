import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:dio/dio.dart' as d;

class StockHistoryRepository {
  final ApiClient apiClient;
  StockHistoryRepository({required this.apiClient});

  // get tv show

  Future<Response> getStockHistory() async{
    var prefs = await SharedPreferences.getInstance();
    String STOCK_HISTORY =
        '/allocation/history/${prefs.getString(AppConstants.USER_CODE)}';
    return await apiClient.getData(STOCK_HISTORY);
  }
  Future<d.Response> getLatestAllocations() async{
    var prefs = await SharedPreferences.getInstance();
    String STOCK_HISTORY =
        '/latest/allocation/${prefs.getString(AppConstants.USER_CODE)}';
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

    // return await apiClient.getData(STOCK_HISTORY);
    return response;
  }

}
