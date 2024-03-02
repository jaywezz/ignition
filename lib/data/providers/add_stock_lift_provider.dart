import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/controllers/stocklift_controller.dart';
import 'package:soko_flow/data/repository/add_stock_lift_repo.dart';
import 'package:soko_flow/data/repository/customer/user_onBoard_permisions_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/requisitions/requisition_products.dart';
import 'package:soko_flow/models/targets/targets_model.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';

import '../repository/customer/customer_repository.dart';

final cartList = StateProvider<List<NewSalesCart>>((ref) => []);

final selectedWarehouseProvider = StateProvider<WarehouseModel?>((ref) => null);

final addStockLiftNotifier =
StateNotifierProvider.autoDispose<AddStockLiftNotifier, AsyncValue>((ref) {
  return AddStockLiftNotifier(read: ref);
});

final warehouseProductsProvider = FutureProvider.family<List<ProductsModel>, String>((ref, warehouseId) async {
  final products = await ref.watch(addStockLiftRepo).getWarehouseProducts(warehouseId);
  return products;
});

final distributorsProvider = FutureProvider<List<DistributorsModel>>((ref) async {
  final distributors= await ref.watch(addStockLiftRepo).getDistributors();
  return distributors;
});

final warehouseProvider = FutureProvider<List<WarehouseModel>>((ref) async {
  final warehouses= await ref.watch(addStockLiftRepo).getWarehouses();
  if(warehouses.isNotEmpty){
    ref.read(selectedWarehouseProvider.state).state = warehouses.first;
  }
  return warehouses;
});

final stockRequisitionsProvider = FutureProvider<List<RequisitionModel>>((ref) async {
  final requisitions= await ref.watch(addStockLiftRepo).getRequisitions();
  return requisitions.reversed.toList();
});


class AddStockLiftNotifier extends StateNotifier<AsyncValue> {
  AddStockLiftNotifier({required this.read})
      : super(const AsyncValue.data(null));
  Ref read;

  Future<void> addStockLift(File receiptFile, String distributorId, String warehouseCode) async {
    String jsonCart = jsonEncode(read.read(cartList));
    state = const AsyncValue.loading();
    try {
      final responseModel = await read
          .read(addStockLiftRepo).addStockLift(jsonCart, receiptFile, distributorId, warehouseCode);
      showCustomSnackBar("StockLift requested", isError: false);
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showCustomSnackBar("An error occurred", isError: true);
      state = AsyncValue.error(e.toString(), s);
    }
  }

  Future<void> addRequisitionProducts(List<RequisitionProducts> products, String requisitionId) async {
    state = const AsyncValue.loading();
    var jsonCart = [];
    for(RequisitionProducts item in products){
      jsonCart.add(
          { "product_id": item.productId,
            "quantity": item.quantity}
      );
    }
    try {
      final responseModel = await read.read(addStockLiftRepo).addRequisitionProducts(jsonCart, requisitionId);
      showCustomSnackBar("Successfully loaded", isError: false);
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showCustomSnackBar("An error occurred", isError: true);
      state = AsyncValue.error(e.toString(), s);
    }
  }

  Future<void> stockRequisition(String warehouseCode) async {
    var jsonCart = {"requisition_products":[]};
    state = const AsyncValue.loading();
    for(NewSalesCart cartItem in read.read(cartList)){
      jsonCart["requisition_products"]!.add(
        { "product_id": cartItem.productMo!.productId,
        "quantity": cartItem.qty}
      );
    }
    try {
      final responseModel = await read.read(addStockLiftRepo).stockRequisition(jsonCart, warehouseCode);
      showCustomSnackBar("Stock requested", isError: false);
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showCustomSnackBar("An error occurred", isError: true);
      state = AsyncValue.error(e.toString(), s);
    }
  }

  Future<void> editStockRequisition(String requisitionId) async {
    var jsonCart = {"requisition_products":[]};
    state = const AsyncValue.loading();
    for(NewSalesCart cartItem in read.read(cartList)){
      jsonCart["requisition_products"]!.add(
          { "product_id": cartItem.productMo!.productId,
            "quantity": cartItem.qty}
      );
    }
    try {
      final responseModel = await read.read(addStockLiftRepo).editStockRequisition(jsonCart, requisitionId);
      showCustomSnackBar("Stock request Updated", isError: false);
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showCustomSnackBar("An error occurred", isError: true);
      state = AsyncValue.error(e.toString(), s);
    }
  }

  addStockLiftCart(NewSalesCart cartProduct){
    final _cartList = read.read(cartList);
    if(_cartList.map((item) => item.productMo!.productId).contains(cartProduct.productMo!.productId)){
      print(_cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId));
      int index = _cartList.indexWhere((element) => element.productMo!.productId == cartProduct.productMo!.productId);
      _cartList[index].qty = cartProduct.qty;
    }else{
      print("false");
      _cartList.add(cartProduct);
    }
    _cartList.forEach((item) {
      print("price: ${item.productMo!.retailPrice!}");
      print("qty: ${item.qty}");
      totalCartPrice += item.totalPrice();
    });
    // print("New lst cart ${cartList}");
    _cartList.forEach((element) {print(element.productMo!.productName);});
    _cartList.forEach((element) {print(element.qty);});
  }
}

double totalCartPrice = 0;