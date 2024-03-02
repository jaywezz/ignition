import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/data/repository/reconcile_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/models/reconcile/cash_reconcile_model.dart';
import 'package:soko_flow/models/response_model.dart';
import 'package:dio/dio.dart' as d;


class ReconcileController extends GetxController{
  final ReconcileRepo reconcileRepo;

  ReconcileController({required this.reconcileRepo});

  List<ReconcileCart> _reconcileCartList = [];
  List<ReconcileCart> get reconcileCartList => _reconcileCartList;

  TextEditingController mpesaAmountController = TextEditingController();
  TextEditingController cashAmountController = TextEditingController();
  TextEditingController chequeAmountController = TextEditingController();
  TextEditingController bankAmountController = TextEditingController();

  int totalExpectedAmount = 0;

  List<DistributorsModel> _distributorsList = [];
  List<DistributorsModel> get distributorsList => _distributorsList;
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  double totalCartPrice = 0;


  DistributorsModel selectedDistributor = DistributorsModel();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void onInit()async {
    // TODO: implement onIni

    super.onInit();
  }


  getDistributors() async {
    _isLoading = true;
    distributorsList.clear();
    try {
      await reconcileRepo.getDistributors().then(
              (resp) {
            distributorsList.addAll(Distributors
                .fromJson(resp.data)
                .distributorsList);
            if(distributorsList.isNotEmpty){
              selectedDistributor = _distributorsList[0];
            }
            _log.i(resp.data);
            _log.i(distributorsList.length);
          }, onError: (err) {
        showCustomSnackBar("Error getting Distributors", isError: true);
        // showSnackBar('Error', err.toString(), Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception) {
      _isLoading = false;
      update();
      showCustomSnackBar("Error occurred", isError: true);;
    }
  }
  getWarehouse() async {
    _isLoading = true;
    distributorsList.clear();
    try {
      await reconcileRepo.getDistributors().then(
              (resp) {
            distributorsList.addAll(Distributors
                .fromJson(resp.data)
                .distributorsList);
            if(distributorsList.isNotEmpty){
              selectedDistributor = _distributorsList[0];
            }
            _log.i(resp.data);
            _log.i(distributorsList.length);
          }, onError: (err) {
        showCustomSnackBar("Error getting Warehouse", isError: true);
        // showSnackBar('Error', err.toString(), Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception) {
      _isLoading = false;
      update();
      showCustomSnackBar("Error getting warehouses", isError: true);;
    }
  }

  getCashReconcile() async {
    _isLoading = true;
    try {
      await reconcileRepo.getReconcileCash().then(
              (resp) {
            mpesaAmountController.text = CashReconcile
                .fromJson(resp.data)
                .mpesaMoney[0].mpesa.toString();
            cashAmountController.text = CashReconcile
                .fromJson(resp.data)
                .cashMoney[0].cash.toString();
            chequeAmountController.text = CashReconcile
                .fromJson(resp.data)
                .chequeMoney[0].cheque.toString();
            bankAmountController.text = CashReconcile
                .fromJson(resp.data).bankMoney[0].bank.toString();

            totalExpectedAmount = int.parse(mpesaAmountController.text) +  int.parse(cashAmountController.text) +  int.parse(chequeAmountController.text)+ int.parse(bankAmountController.text);
            _log.i(resp.data);
            _log.i(distributorsList.length);
          }, onError: (err) {
        showCustomSnackBar("Error reconciling amount", isError: true);
        // showSnackBar('Error', err.toString(), Colors.red);
      });
      _isLoading = false;
      update();
    } catch (exception) {
      _isLoading = false;
      update();
      showCustomSnackBar("Error occurred getting cash reconcile. Try again later", isError: true);;
    }
  }

  Future<d.Response> reconcileStock(String warehouseCode, String distributorId) async {
   try{
     _isLoading = true;
     // print("cart data ${_cartData}");
     update();
     String jsonCart = jsonEncode(_reconcileCartList);
     print(jsonCart);
     var cartData = [];
     _reconcileCartList.forEach((element) {
       cartData.add({
         "productID": element.latestAllocationModel!.id,
         "amount": element.qty,
         "supplierID": distributorId
       });
     });

     print("json cart at the controller ${jsonCart}");
     var data = {
       "cart": cartData,
       "cash": cashAmountController.text,
       "mpesa": mpesaAmountController.text,
       "cheque": chequeAmountController.text,
       "bank": bankAmountController.text
     };
     d.Response response = await reconcileRepo.reconcileStock(data, warehouseCode, distributorId);
     late ResponseModel responseModel;
     if (response.statusCode == 200) {
       showCustomSnackBar("Successfully requested reconcile", isError: false);

       _isLoading = false;
       Get.close(2);
       update();
       responseModel = ResponseModel(true, response.data["message"]);
     }
     else {

       showCustomSnackBar("An error occurred", isError: true);
       _isLoading = false;
       print(response.data);
       update();
       responseModel = ResponseModel(false, response.data["message"]);
     }
     _isLoading = false;
     reconcileCartList.clear();
     update();
     return response;
   }catch(e){
     _isLoading = false;
     showCustomSnackBar("An error occurred. Try again later", isError: true);
     throw e;
   }
  }

  addVanSalesCart(ReconcileCart reconcileCart){

    if(_reconcileCartList.map((item) => item.latestAllocationModel!.id).contains(reconcileCart.latestAllocationModel!.id)){
      // print(_cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId));
      int index = _reconcileCartList.indexWhere((element) =>element.latestAllocationModel!.id == reconcileCart.latestAllocationModel!.id);
      print(index);
      _reconcileCartList[index].qty = reconcileCart.qty;

      update();
      print("New lst cart ${reconcileCartList}");
    }else{
      print("false");
      _reconcileCartList.add(reconcileCart);
    }

    update();

    print("New lst cart ${reconcileCart}");


  }
}