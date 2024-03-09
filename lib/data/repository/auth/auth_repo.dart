import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as myget;
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../../controllers/customer_checking_controller.dart';
import '../../../controllers/customers_controller.dart';
import '../../../helper/dio_exceptions.dart';

final authRepo =
Provider<AuthenticationRepositoryAPI>((ref) => AuthenticationRepositoryAPI(ref));

class AuthenticationRepositoryAPI{
  final Ref read;
  AuthenticationRepositoryAPI(this.read);

  Future<Response> userLogin(String email, String password) async {
    try {
      return await read.read(clientProvider).post(
          AppConstants.LOGIN_URI, data: {"email": email, "password": password});
    }
    catch(e){
      throw e;
    }

  }

  Future<Response> otpLogin(String phoneNumber, String otp)async{
    try {
      return  await read.read(clientProvider).post(
          "verify/otp/$phoneNumber/$otp",data: { "phone_number": phoneNumber,
        "otp": otp, "device_token": "",});
    } on DioExceptions catch (e, s) {
      throw e;
    } catch (e, s) {
      print(s);
      throw "An unknown error occurred. Try again later";
    }
  }

  Future<Response> sendOtp(String phoneNumber)async{
    try {
      return  await read.read(clientProvider).post(
          "otplogin/",data: {"phone_number" : phoneNumber,});
    } on DioExceptions catch (e) {
      throw e;
    } catch (e, s) {
      throw "An unknown error occurred. Try again later";
    }
  }
}
