import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api_service/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String email, String password) async {
    return await apiClient.postData(
        AppConstants.LOGIN_URI, {"email": email, "password": password});
  }

  Future<Response> sendOtp(String phone) async {
    return await apiClient.postData("/send/otp/$phone", {});
  }

  Future<Response> verifyOtp(String phone, String otp) async {
    return await apiClient.postData("/verify/otp/$phone/$otp", {});
  }

  Future<Response> resetPassword(
      String phone, String password, String password_confirm) async {
    return await apiClient.postData(AppConstants.CHANGE_PASSWORD, {
      "phone_number": phone,
      "password": password,
      "password_confirmation": password_confirm
    });
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeaders(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<bool> saveUserId(String id) async {
    return await sharedPreferences.setString(AppConstants.ID, id);
  }

  Future<bool> saveUserName(String name) async {
    return await sharedPreferences.setString(AppConstants.USER_NAME, name);
  }

  Future<bool> saveUserEmail(String email) async {
    return await sharedPreferences.setString(AppConstants.EMAIL, email);
  }

  Future<bool> saveUserPhone(String phone) async {
    return await sharedPreferences.setString(AppConstants.PHONE_NUMBER, phone);
  }

  Future<bool> saveUserCode(String code) async {
    return await sharedPreferences.setString(AppConstants.USER_CODE, code);
  }

  Future<bool> saveBusinessCode(String code) async {
    return await sharedPreferences.setString(AppConstants.BUSINESS_CODE, code);
  }

  // Future<void> saveUserDetails(String id, String user_code, String email,
  //     String phone_number, String name) async {
  //   try {
  //     await sharedPreferences.setString(AppConstants.EMAIL, email);
  //     await sharedPreferences.setString(
  //         AppConstants.PHONE_NUMBER, phone_number);
  //     await sharedPreferences.setString(AppConstants.ID, id);
  //     await sharedPreferences.setString(AppConstants.USER_CODE, user_code);
  //     await sharedPreferences.setString(AppConstants.USER_NAME, name);
  //   } catch (e) {
  //     print(e);
  //     throw e;
  //   }
  // }

  Future<String> getUserToken() async {
    return await sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PHONE_NUMBER);
    sharedPreferences.remove(AppConstants.EMAIL);
    sharedPreferences.remove(AppConstants.ID);
    sharedPreferences.remove(AppConstants.USER_NAME);
    sharedPreferences.remove(AppConstants.USER_CODE);
    apiClient.token = '';
    apiClient.updateHeaders('token');
    return true;
  }
}
