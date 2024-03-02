import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../data/repository/auth_repo.dart';
import '../models/response_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController implements GetxService {
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  final AuthRepo authRepo;
  AuthController({required this.authRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> login(String phone, String password) async {
    _log.d("Getting token");
    _log.i(authRepo.getUserToken().toString());
    _isLoading = true;
    update();
    try{
      Response response = await authRepo.login(phone, password);
      late ResponseModel responseModel;
      print("status headers: ${response.statusText}");
      if (response.statusCode == 200) {
        _log.i("Backend token" + response.body["access_token"]);
        authRepo.saveUserToken(response.body["access_token"]);
        AuthService.instance.login(response.body);
        await authRepo.saveUserCode(
          response.body["user"]["user_code"],
        );
        await authRepo.saveUserEmail(
          response.body["user"]["email"] ?? "",
        );
        await authRepo.saveUserPhone(
          response.body["user"]["phone_number"] ?? "",
        );
        await authRepo.saveUserName(response.body["user"]["name"] ?? "");
        await authRepo
            .saveBusinessCode(response.body["user"]["business_code"] ?? "");
        await authRepo.saveUserId(
          response.body["user"]["id"].toString(),
        );
        // authRepo.saveUserDetails(
        //     response.body["user"]["id"].toString(),
        //     response.body["user"]["user_code"],
        //     response.body["user"]["email"],
        //     response.body["user"]["phone_number"],
        //     response.body["user"]["name"]);

        responseModel = ResponseModel(true, response.body["message"]);
      } else {
        print("status code: ${response}");
        responseModel = ResponseModel(false, response.body["message"]);
      }
      _isLoading = false;
      update();
      return responseModel;
    }catch(e){
      _isLoading = false;
      update();
      print("an error occurred: $e");
      throw e;
    }
  }

  Future<Response> sendOtp(String phone) async {
    _isLoading = true;
    update();
    Response response = await authRepo.sendOtp(phone);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      _log.i(response.body);
      responseModel = ResponseModel(true, response.statusText!);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<ResponseModel> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyOtp(phone, otp);
    late ResponseModel responseModel;
    if (response.body["message"] == "Valid OTP entered") {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.body["message"]);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String phone, String password, String password_confirm) async {
    _isLoading = true;
    update();
    Response response =
    await authRepo.resetPassword(phone, password, password_confirm);
    late ResponseModel responseModel;
    if (response.body["message"] == "Password has been changed sucessfully") {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.body["message"]);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String email, String password) {
    // authRepo.saveUserDetails(email, password);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }
}
