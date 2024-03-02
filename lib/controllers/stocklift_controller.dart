import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/data/repository/stocklift_repo.dart';
import 'package:soko_flow/data/repository/add_to_cart_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/response_model.dart';

import '../base/show_custom_snackbar.dart';
import '../models/distributors_model.dart';
import 'package:dio/dio.dart' as dioCast;

class StockLiftController extends GetxController{
  final AddStockLiftRepo stockLiftRepo;

  StockLiftController({required this.stockLiftRepo});

  List<NewSalesCart> _cartList = [];
  double totalCartPrice = 0;
  File? pickedImage;

  List<NewSalesCart> get cartList => _cartList;

  List<DistributorsModel> _distributorsList = [];
  List<DistributorsModel> get distributorsList => _distributorsList;

  List<ProductsModel> _productList = [];
  List<ProductsModel> get productList => _productList;

  DistributorsModel selectedDistributor = DistributorsModel();




  bool _isLoading = false;
  bool get isLoading => _isLoading;


  @override
  void onInit() {
    // TODO: implement onInit
    // getDistributors();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    //For Pagination
  }

  @override
  void onClose() {
    super.onClose();
  }

  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  // getDistributors() async {
  //   _isLoading = true;
  //   distributorsList.clear();
  //   try {
  //     await stockLiftRepo.getDistributors().then(
  //             (resp) {
  //           distributorsList.addAll(Distributors
  //               .fromJson(resp.body)
  //               .distributorsList);
  //           if(distributorsList.isNotEmpty){
  //             selectedDistributor = _distributorsList[0];
  //           }
  //           _log.i(resp.body);
  //           _log.i(distributorsList.length);
  //         }, onError: (err) {
  //               showCustomSnackBar("Error getting Distributors", isError: true);
  //       // showSnackBar('Error', err.toString(), Colors.red);
  //     });
  //     await getDistributorProducts();
  //     _isLoading = false;
  //     update();
  //   } catch (exception) {
  //     _isLoading = false;
  //     update();
  //     showCustomSnackBar(exception.toString(), isError: true);;
  //   }
  // }
  //
  // Future<void> getDistributorProducts() async {
  //   _isLoading = true;
  //   print("getting distributor products for id: ${selectedDistributor.id.toString()}");
  //   Response response = await stockLiftRepo.getDistributorsProducts(selectedDistributor.id.toString());
  //   if (response.statusCode == 200) {
  //     _log.d('...Got products...');
  //
  //     _productList = [];
  //     _productList.addAll(Product
  //         .fromJson(response.body)
  //         .products);
  //     _log.i(response.body);
  //     _log.i(_productList.length);
  //     _isLoading = false;
  //     update();
  //   }
  //   else {
  //     _log.e('Could not Get Products');
  //     //print('Could not Get Ontrack Customers');
  //   }
  // }

  //
  // Future<dioCast.Response> addStockLift(File receiptFile) async{
  //   _isLoading = true;
  //   // print("cart data ${_cartData}");
  //   update();
  //   String jsonCart = jsonEncode(_cartList);
  //   print(jsonCart);
  //
  //   dioCast.Response response = await stockLiftRepo.addStockLift(jsonCart, receiptFile);
  //   late ResponseModel responseModel;
  //   if (response.statusCode == 200) {
  //     showCustomSnackBar("StockLift requested", isError: false);
  //     _isLoading = false;
  //     update();
  //     responseModel = ResponseModel(true, response.data["message"]);
  //   } else {
  //     showCustomSnackBar("An error occurred", isError: true);
  //     _isLoading = false;
  //     print(response.data);
  //     update();
  //     responseModel = ResponseModel(false, response.data["message"]);
  //   }
  //   _isLoading = false;
  //   _cartList.clear();
  //   update();
  //   return response;
  // }

  addStockLiftCart(NewSalesCart cartProduct){

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
      print("price: ${item.productMo!.retailPrice!}");
      print("qty: ${item.qty}");
      totalCartPrice += item.totalPrice();
    });
    update();
    // print("New lst cart ${cartList}");
    cartList.forEach((element) {print(element.productMo!.productName);});
    cartList.forEach((element) {print(element.qty);});
  }


}