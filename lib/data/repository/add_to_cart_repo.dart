import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';

import '../../utils/app_constants.dart';
import '../api_service/api_client.dart';
import 'package:dio/dio.dart' as d;
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class AddToCartRepo {
  final ApiClient apiClient;

  AddToCartRepo({required this.apiClient});

  Future<d.Response> addOrderCart(String cartData, String distributorId) async {
    print("selected disti number: ${distributorId}");
    dio.interceptors.add(
      d.LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    Logger().e(getRandomString(10));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("CheckinCode ${prefs.getString('checkinCode')}");
    final d.Response response = await dio.post("/checkin/newsales/${prefs.getInt('customerId')}/${getRandomString(10)}/$distributorId/add-to-cart",data: cartData);
    // return await apiClient.postData(
    //     "/checkin/newsales/${prefs.getInt('customerId')}/${getRandomString(10)}/$distributorId/add-to-cart",
    //     cartData);
    return response;
  }

  Future<Response> addVanCart(String cartData, String discount) async {
    Random _rnd = Random();
    var data =  [{"cartItem": cartData}];
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("checking code : ${prefs.getString('checkinCode')}");
    print("${AppConstants.BASE_URL}/checkin/vansales/${prefs.getInt('customerId')}/${getRandomString(10)}/add-to-cart");
    // print("cart data : ${jsonDecode(data.toString())}");
    return await apiClient.postData(
        "/checkin/vansales/${prefs.getInt('customerId')}/${getRandomString(10)}/add-to-cart", jsonDecode('''[{"cartItem": "${cartData.toString()}"]''')
   );
  }
}

String getRandomString(int length) {
  const characters =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}



