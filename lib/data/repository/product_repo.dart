import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../api_service/api_client.dart';

class ProductRepo extends GetxService {
  final ApiClient apiClient;
  ProductRepo({required this.apiClient});

  Future<Response> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessCode = await prefs.getString(AppConstants.BUSINESS_CODE)!;
    return await apiClient.getData("${AppConstants.PRODUCTS}$businessCode");
  }
}
