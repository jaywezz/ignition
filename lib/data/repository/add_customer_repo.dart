import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api_service/api_client.dart';

class AddCustomerRepo {
  final ApiClient apiClient;

  AddCustomerRepo({required this.apiClient});

  Future<Response> addCustomer(
      String customer_name,
      String email,
      String contact_person,
      String phone_number,
      String latitude,
      String longitude,
      String address) async {
    var prefs = await SharedPreferences.getInstance();
    String business_code = (await prefs.getString(AppConstants.BUSINESS_CODE))!;
    String user_code = (await prefs.getString(AppConstants.USER_CODE))!;
    return await apiClient.postData(AppConstants.ADD_CUSTOMERS, {
      "customer_name": customer_name,
      "email": email,
      "contact_person": contact_person,
      "business_code": business_code,
      "created_by": "John mbugua",
      "user code": user_code,
      "phone_number": phone_number,
      "latitude": latitude,
      "longitude": longitude,
      "address": address
    });
  }
}
