import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/repository/products_repo/products_repo_provider.dart';
import 'package:soko_flow/data/repository/routes_repo.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/response_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';

import '../../models/customer_model/customer_model.dart';

final productsProvider = FutureProvider<List<ProductsModel>>((ref) async {
  final products = await ref.watch(productsRepo).getProducts(false);
  return products;
});

final searchValueProvider = StateProvider<TextEditingController>((ref)=> TextEditingController());

// final filteredProductsProvider = Provider((ref) async{
//   String searchValue = ref.watch(searchValueProvider).text;
//   return ref.watch(productsProvider).whenData((products) {
//     if(searchValue.isNotEmpty){
//       return products.where((element) => element.productName!.contains(searchValue));
//     }else{
//       return products;
//     }
//   });
// });

final filteredProductsProvider = StateProvider((ref) {
  String searchValue = ref.watch(searchValueProvider).text;
  print("value $searchValue");
  return ref.watch(productsProvider).whenData((products) {
    if(searchValue.isNotEmpty){

      return products.where((element) => element.productName!.toLowerCase().contains(searchValue.toLowerCase())).toList();
    }else{
      return products;
    }
  });
});

