import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/controllers/customers_controller.dart';
import 'package:soko_flow/data/repository/customer/user_onBoard_permisions_repo.dart';
import 'package:soko_flow/models/targets/targets_model.dart';
import 'package:soko_flow/routes/route_helper.dart';

import '../repository/customer/customer_repository.dart';


class AddCustomerNotifier extends StateNotifier<AsyncValue> {
  AddCustomerNotifier({required this.read})
      : super(const AsyncValue.data(null));
  Ref read;

  Future<void> addCustomer(
      String customer_name,
      String email,
      String contact_person,
      String business_code,
      String created_by,
      String phone_number,
      String alternativePhone,
      String outlet,
      String latitude,
      String longitude,
      String routeCode,
      String address,
      File? image) async {
    state = const AsyncValue.loading();
    try {
      final responseModel = await read
          .read(CustomerRepositoryProvider)
          .addCustomer(customer_name, email, contact_person, business_code,
          created_by, phone_number, alternativePhone, outlet, latitude, longitude,routeCode, address, image == null?null:image);
      showSnackBar(text: "Customer added successfully");
      Get.find<CustomersController>().getCustomers(500, true);
      Get.offNamed(RouteHelper.getCustomers());
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showSnackBar(text: e.toString(), bgColor: Colors.red);
      print("error: ${s}");
      state = AsyncValue.error(e.toString(), s);
    }
    // state = await AsyncValue.guard(
    //   () => loginRepository.loginUser(email, password),
    // );
  }

  Future<void> editCustomer({
    required String customer_name,
    required String email,
    required businessCode,
    required String contact_person,
    required String phone_number,
    required String alternativePhone,
    required String? outlet,
    required String? latitude,
    required String? longitude,
    required String? routeCode,
    required String? address}
      ) async {
    state = const AsyncValue.loading();
    try {
      print("editing");
      final responseModel = await read
          .read(CustomerRepositoryProvider).editCustomer(customer_name:customer_name, email:email, contact_person:contact_person,
          phone_number:phone_number, alternativePhone:alternativePhone, outlet:outlet == null?null:outlet, latitude:latitude, longitude:longitude,routeCode:routeCode, address:address, businessCode: businessCode);
      showSnackBar(text: "Customer edited successfully");
      Get.find<CustomersController>().getCustomers(500, true);
      Get.offNamed(RouteHelper.getCustomers());
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showSnackBar(text:"An error occurred", bgColor: Colors.red);
      state = AsyncValue.error(e.toString(), s);
    }
    // state = await AsyncValue.guard(
    //   () => loginRepository.loginUser(email, password),
    // );
  }


}
