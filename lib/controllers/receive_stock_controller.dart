import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/repository/receive_stock_repo.dart';
import 'package:soko_flow/models/customer_deliveries.dart';

import '../models/receiveStock/receive_stock_model.dart';

class ReceiveStockController extends GetxController{
  final ReceiveStockRepo receiveStockRepo;

  ReceiveStockController({required this.receiveStockRepo});

  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  List<ReceiveStockModel> _listReceiveItems = [];
  List<ReceiveStockModel> get listReceiveItems => _listReceiveItems;
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  getReceiveStockItems() async {
    _isLoading = true;
    listReceiveItems.clear();
    try {
      await receiveStockRepo.getReceiveStockItems().then(
              (resp) {
            listReceiveItems.addAll(ReceiveStock
                .fromJson(resp.body)
                .receiveStockItems);
            _log.i(resp.body);
          }, onError: (err) {
        showCustomSnackBar("Error getting Items", isError: true);
        // showSnackBar('Error', err.toString(), Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception) {
      _isLoading = false;
      update();
      showCustomSnackBar(exception.toString(), isError: true);;
    }
  }



}