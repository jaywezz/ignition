
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/auth/auth_repo.dart';
import 'package:soko_flow/data/repository/auth_repo.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/auth_service.dart';
import 'package:soko_flow/utils/app_constants.dart';

final authNotifier =
StateNotifierProvider.autoDispose< AuthNotifier, AsyncValue>((ref) {
  return  AuthNotifier(read: ref);
});

class AuthNotifier extends StateNotifier<AsyncValue> {
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  AuthNotifier({required this.read})
      : super(const AsyncValue.data(null));
  Ref read;

  Future<void> userLogin(String phoneNumber, String password) async {
    state = const AsyncValue.loading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiClient apiClient = ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: prefs);
    AuthRepo authRepository =AuthRepo(apiClient: apiClient, sharedPreferences: prefs);

    try {
      final responseModel = await read.read(authRepo).userLogin(
          phoneNumber, password);
      _log.i("Backend token" + responseModel.data["access_token"]);
      authRepository.saveUserToken(responseModel.data["access_token"]);
      AuthService.instance.login(responseModel.data);
      await authRepository.saveUserCode(
        responseModel.data["user"]["user_code"],
      );
      await authRepository.saveUserEmail(
        responseModel.data["user"]["email"] ?? "",
      );
      await authRepository.saveUserPhone(
        responseModel.data["user"]["phone_number"] ?? "",
      );
      await authRepository.saveUserName(
          responseModel.data["user"]["name"] ?? "");
      await authRepository.saveBusinessCode(
          responseModel.data["user"]["business_code"] ?? "");
      await authRepository.saveUserId(
        responseModel.data["user"]["id"].toString(),
      );
      // await authRepository.saveUserRegion(
      //   responseModel.data["user"]["route_code"].toString(),
      // );
      showSnackBar(text: "Successfully logged in", bgColor: Colors.green);
      Get.toNamed(RouteHelper.getInitial());
      state = AsyncValue.data(responseModel);
    }on DioError catch (e, s) {
      showSnackBar(text: DioExceptions.fromDioError(e).message, bgColor: Colors.red);
      state = AsyncValue.error(e.toString(),s);
      throw DioExceptions.fromDioError(e);
    }catch (e, s) {
      state = AsyncValue.error(e.toString(), s);
      showSnackBar(text: "An error occurred", bgColor: Colors.red);
      throw e;
    }
  }


}
