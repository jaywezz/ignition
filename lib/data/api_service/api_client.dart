import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';

class ApiClient extends GetConnect implements GetxService {
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = AppConstants.BASE_URL;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    print("token : ${'Bearer ${sharedPreferences.getString(AppConstants.TOKEN)}'}");
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${sharedPreferences.getString(AppConstants.TOKEN)}'
    };
  }
  void updateHeaders(String token) {
    _log.i("My update Headers Api Client token: $token");
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await get(
        uri,
        headers: headers ?? _mainHeaders
      );
      print(response.body);
      // _log.i(response.body);
      // _log.i(
          // "Token in storage: ${sharedPreferences.getString(AppConstants.TOKEN) ?? "null"}");
      return response;
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: e.toString(),
      );
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    _log.i("Data posted to api is " + body.toString());
    _log.i(
        "Token in storage: ${sharedPreferences.getString(AppConstants.TOKEN) ?? "null"}");
    print("mainheader: ${_mainHeaders}");
    _log.i("The uri: $uri");
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      //!TODO: In the future we need to add this line in the post method next to body , headers: _mainHeaders,
      _log.i(response.toString());
      print(response.body);
      return response;
    } catch (e) {
      _log.e(e);
      return Response(
        statusCode: 1,
        statusText: e.toString(),
      );
    }
  }
}
