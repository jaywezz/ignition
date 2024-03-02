import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/models/order_history_model.dart';
import 'package:soko_flow/models/orders_details_model.dart';

import '../data/repository/order_repository.dart';


class OrderDetailsController extends GetxController {
  OrderRepository orderRepository;
  OrderDetailsController({required this.orderRepository});
  // List<OrdersDetails> orderdetailslist = List<OrdersDetails>.empty(growable: true).obs;
  List<OrderItem> orderitems = List<OrderItem>.empty(growable: true).obs;
  List<PaymentModel> orderPayments = List<PaymentModel>.empty(growable: true).obs;
  OrdersModel orderData = OrdersModel();


  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  bool isLoading = false;

  var connectionStatus = 0.obs;

  //bool isConnected=await InternetConnectionChecker().hasConnection;
  late StreamSubscription<InternetConnectionStatus> _listener;

  @override
  void onInit() {
    super.onInit();
    _listener = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          connectionStatus.value = 1;
          break;
        case InternetConnectionStatus.disconnected:
          connectionStatus.value = 0;
          break;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // getOrderDetails("qQjoXQUz");
    //For Pagination

  }

  @override
  void onClose() {
    _listener.cancel();
    super.onClose();
  }


  getOrderDetails(String order_code) async {

    orderitems.clear();
    orderPayments.clear();
    isLoading = true;
    update();
    print("Controller order code : ${order_code}");
    try{
      isLoading = true;
      update();
      await orderRepository.getOrderDetails(order_code).then((response) {
        orderitems.addAll(OrderDetailsData.fromJson(response.data).ordersList);
        orderPayments.addAll(OrderDetailsData.fromJson(response.data).orderPayments);
        orderData = OrderDetailsData.fromJson(response.data).orderMade;
        update();
      });
      isLoading = false;
      update();
    }catch(exception,s){
      isLoading = false;
      update();
      print("error getting order details: ${s}");
      showSnackBar('An error has occurred processing order details', "", Colors.red);
    }
  }

  //common snack bar
  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
}
