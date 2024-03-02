import 'dart:io';import 'package:dio/dio.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';import 'package:shared_preferences/shared_preferences.dart';import 'package:soko_flow/data/hive_database/hive_constants.dart';import 'package:soko_flow/data/hive_database/hive_manager.dart';import 'package:soko_flow/data/providers/client_provider.dart';import 'package:soko_flow/models/productsModel/products_model.dart';import 'package:soko_flow/utils/app_constants.dart';import '../../../helper/dio_exceptions.dart';final productsRepo =Provider<ProductsRepositoryAPI>((ref) => ProductsRepositoryAPI(ref));class ProductsRepositoryAPI{  final Ref read;  ProductsRepositoryAPI(this.read);  Future<List<ProductsModel>> getProducts(bool isSync) async {    List<ProductsModel> products = [];    try {      await HiveDataManager(HiveBoxConstants.productsDb).getHiveData().then((box){        if(box.isNotEmpty){          products.addAll(box.get(HiveBoxConstants.productsDb).cast<ProductsModel>());        }      });      if(products.isNotEmpty && isSync == false){        print("Offline products");        return products;      }else{        print("Online products");        SharedPreferences prefs = await SharedPreferences.getInstance();        String businessCode = await prefs.getString(AppConstants.BUSINESS_CODE)!;        final response = await read.read(clientProvider).get("/products/$businessCode");        products = productsFromJson(response.data["data"]);        HiveDataManager(HiveBoxConstants.productsDb).addHiveData(products);        return products;      }    } on DioError catch (e) {      throw DioExceptions.fromDioError(e);    }catch(e,s){      print(s);      throw e;    }  }}