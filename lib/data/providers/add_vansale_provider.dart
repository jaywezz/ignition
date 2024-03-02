import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/repository/add_vansale_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';


final addVanSaleNotifier =
StateNotifierProvider.autoDispose<AddVanSaleNotifier, AsyncValue>((ref) {
  return AddVanSaleNotifier(read: ref);
});

class AddVanSaleNotifier extends StateNotifier<AsyncValue> {
  AddVanSaleNotifier({required this.read})
      : super(const AsyncValue.data(null));
  Ref read;

  Future<d.Response> addVanSale() async {
    state = const AsyncValue.loading();
    try {
      var jsonCart = {"cartItem":[]};
      // jsonEncode(Get.find<AddToCartController>().vanCartList)
      // String jsonCart = jsonEncode(Get.find<AddToCartController>().vanCartList);
      for(VanSalesCart cartItem in Get.find<AddToCartController>().vanCartList){
        jsonCart["cartItem"]!.add(
            { "productID": cartItem.latestAllocationModel!.id,
              "qty": cartItem.qty,
              "price":cartItem.price
            }
        );
      }
      final responseModel = await read.read(vanSaleRepo).addVanSale([jsonCart], "");
      // state = AsyncValue.data(responseModel);
      Get.find<PaymentController>().orderCode = responseModel.data["order_code"];
      showCustomSnackBar("Successfully made VanSale", isError: false);
      // Get.find<AddToCartController>().isLoading = false;
      // state = AsyncValue.data(responseModel);
      Get.find<AddToCartController>().vanCartList.clear();
      Get.find<PaymentController>().update();
      return responseModel;
    } catch (e, s) {
      showCustomSnackBar("An error occurred", isError: true);
      print("error :${s}");
      state = AsyncValue.error(e.toString(), s);
      throw e;
    }
  }
}