import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';

import '../data/repository/add_to_cart_repo.dart';
import '../models/response_model.dart';
import 'package:dio/dio.dart' as d;

class AddToCartController extends GetxController {
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  final AddToCartRepo cartRepo;
  AddToCartController({required this.cartRepo});
  List<NewSalesCart> _cartList = [];
  List<NewSalesCart> get cartList => _cartList;

  List<VanSalesCart> _vanSalesCartList = [];
  List<VanSalesCart> get vanCartList => _vanSalesCartList;
  double totalCartPrice = 0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //
  // showSnackBar(String title, String message, Color backgroundColor) {
  //   Get.snackbar(
  //     title,
  //     message,
  //     snackPosition: SnackPosition.TOP,
  //     backgroundColor: backgroundColor,
  //     colorText: Colors.white,
  //   );
  // }



  @override
  void onReady() {
    super.onReady();
    // getStockHistory("all");
    //For Pagination
  }

  @override
  void onClose() {
    cartList.clear();
    super.onClose();
  }




  Future<d.Response> addToOrderCart(String distributorId) async {
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(NewSalesCartAdapter());
    }
    _isLoading = true;
    // print("cart data ${_cartData}");
    update();

    String jsonCart = jsonEncode(_cartList);
    print(jsonCart);

    d.Response response = await cartRepo.addOrderCart(jsonCart, distributorId );
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      showCustomSnackBar("Successfully made order", isError: false);
      _isLoading = false;
      Get.find<PaymentController>().orderCode = response.data["order_code"];
      Get.find<PaymentController>().update();
      update();
      responseModel = ResponseModel(true, response.data["message"]);
    } else if(response.statusCode == null){
      await HiveDataManager(HiveBoxConstants.newLeadsDb).addHiveData(
          _cartList
      );
      var r = Random();
      Get.find<PaymentController>().orderCode = String.fromCharCodes(List.generate(5, (index) => r.nextInt(33) + 89));
      _isLoading = false;
      update();
      return response;
    }else {
      showCustomSnackBar("An error occurred", isError: true);
      _isLoading = false;
      print(response.data);
      update();
      responseModel = ResponseModel(false, response.data["message"]);
    }
    _isLoading = false;
    _cartList.clear();
    update();
    return response;
  }

  Future<Response> addToVanCart(String discount) async {
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(VanSalesCartAdapter());
    }
    _isLoading = true;
    // print("cart data ${_cartData}");
    update();
    String jsonCart = jsonEncode(_vanSalesCartList);
    print(jsonCart);

    print("json cart at the controller ${jsonCart}");
    Response response = await cartRepo.addVanCart(jsonCart, discount);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      showCustomSnackBar("Successfully made van sale", isError: false);
      Get.find<PaymentController>().orderCode = response.body["order_code"];
      Get.find<PaymentController>().update();

      _isLoading = false;
      update();
      responseModel = ResponseModel(true, response.body["message"]);
    }else if(response.statusCode == null){
      print("recorded van sale offline");
      await HiveDataManager(HiveBoxConstants.vanSales).addHiveData(_vanSalesCartList);
      var r = Random();
      showCustomSnackBar("Recorded Vansale offline", bgColor: Colors.blue, isError: false);
      Get.find<PaymentController>().orderCode = String.fromCharCodes(List.generate(5, (index) => r.nextInt(33) + 89));
      _isLoading = false;
      update();
      return Response(statusCode: 0, statusText: "VanSale Recorded offline");
    }
    else {

      showCustomSnackBar("An error occurred", isError: false);
      _isLoading = false;
      print(response.body);
      update();
      responseModel = ResponseModel(false, response.body["message"]);
    }
    _isLoading = false;
    _cartList.clear();
    update();
    return response;
  }


  addNewSalesCart(NewSalesCart cartProduct){

    if(_cartList.map((item) => item.productMo!.productId).contains(cartProduct.productMo!.productId)){
      print(_cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId));
      int index = _cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId);
      _cartList[index].qty = cartProduct.qty;
      update();
    }else{
      print("false");
      cartList.add(cartProduct);
    }

    totalCartPrice = 0;
    _cartList.forEach((item) {
      print("price: ${item.productMo!.retailPrice}");
      print("qty: ${item.qty}");
      totalCartPrice += item.totalPrice();
    });
    update();
    // print("New lst cart ${cartList}");
    cartList.forEach((element) {print(element.productMo!.productName);});
    cartList.forEach((element) {print(element.qty);});
  }

  addVanSalesCart(VanSalesCart cartProduct){

    if(_vanSalesCartList.map((item) => item.latestAllocationModel!.id).contains(cartProduct.latestAllocationModel!.id)){
      // print(_cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId));
      int index = _vanSalesCartList.indexWhere((element) =>element.latestAllocationModel!.id == cartProduct.latestAllocationModel!.id);
      print(index);
      _vanSalesCartList[index].qty = cartProduct.qty;

      update();
      print("New lst cart ${_cartList}");
    }else{
      print("false");
      vanCartList.add(cartProduct);
    }

    totalCartPrice = 0;
    _vanSalesCartList.forEach((item) {
      totalCartPrice += item.totalPrice();
    });

    update();

    print("New lst cart ${cartList}");


  }
}
