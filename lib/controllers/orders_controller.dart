import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/repository/order_repository.dart';
import 'package:soko_flow/models/customer_orders.dart';
import 'package:soko_flow/models/order_history_model.dart';


class OrdersController extends GetxController {

  OrderRepository orderRepository;
  OrdersController({required this.orderRepository});
  List<OrdersModel> lstorders = List<OrdersModel>.empty(growable: true).obs;
  List<OrdersModel> lstUserorders = List<OrdersModel>.empty(growable: true).obs;
  List<OrdersModel> lstVanSales = List<OrdersModel>.empty(growable: true).obs;

  RxInt customer_id = 0.obs;

  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  var connectionStatus = 0.obs;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FilterPaymentMethods paymentMethod = FilterPaymentMethods.PaymentMethod;
  String filterDateSold= "";
  String filterDatePaid= "";


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
  }

  @override
  void onClose() {
    _listener.cancel();
    super.onClose();
  }

  getSalesOrders(String customer_id) async {
    _isLoading = true;
    lstorders.clear();
    try {
      await orderRepository.getPreOrders(customer_id).then(
              (resp) {
                lstorders.addAll(OrderData
                    .fromJson(resp.data)
                    .ordersList.reversed);
                _log.i(resp.data);

                
                lstorders = lstorders.where((element) => element.orderType == "Pre Order").toList();
                _log.i(lstorders.length);
                update();
          }, onError: (err,s) {
                print("error: ${s}");
            showSnackBar('Error', "An error occurred try again later", Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception,s) {
      _isLoading = false;
      update();
      print("orders error: ${s}");
      showSnackBar('Exception', "An error occurred, try again later", Colors.red);
    }
  }

  getUserOrders() async {
    _isLoading = true;
    lstUserorders.clear();
    try {
      await orderRepository.getUserOrders().then(
              (resp) {
                lstUserorders.addAll(OrderData.fromJson(resp.data)
                .ordersList.reversed);
            // _log.i(resp.data);


            lstUserorders = lstUserorders.where((element) => element.orderType == "Pre Order").toList().reversed.toList();
            _log.i(lstUserorders.length);
            update();
          }, onError: (err) {
        showSnackBar('Error', "An error occurred getting orders", Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception) {
      _isLoading = false;
      update();
      showSnackBar('Error', "An error occurred getting orders", Colors.red);
    }
  }



  Future<int>getPendingVanPayments(String customer_id)async{
    await getVanOrders(customer_id);
    int pendingAmount = 0;
    if(lstVanSales.isEmpty){
      return pendingAmount;
    }else{
      for(OrdersModel vanOrder in lstVanSales){
        if(vanOrder.paymentStatus == "PARTIAL PAID" || vanOrder.paymentStatus == "Pending Payment"){
          pendingAmount= pendingAmount + int.parse(vanOrder.balance!);
        }
      }
      return pendingAmount;
    }
  }

  getVanOrders(String customer_id) async {
    _isLoading = true;
    lstVanSales.clear();
    try {
      await orderRepository.getVanOrders(customer_id).then(
              (resp) {
            lstVanSales.addAll(OrderData
                .fromJson(resp.data)
                .ordersList);
            // _log.i(resp.data);
            _log.i(lstorders.length);
          }, onError: (err) {
        showSnackBar('Error', "An error occurred getting orders", Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception) {
      _isLoading = false;
      update();
      showSnackBar('Error', "An error occurred getting sales", Colors.red);
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

enum FilterPaymentMethods {PaymentMethod, Mpesa, Cheque, Cash }