import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/api_service/api_client.dart';

class ReceiveStockRepo {
  final ApiClient apiClient;

  ReceiveStockRepo({required this.apiClient});

  Future<Response> getReceiveStockItems() async{
    String RECEIVE_STOCK_ITEMS ='/stocklift/receive';
    return await apiClient.getData(RECEIVE_STOCK_ITEMS);
  }
}