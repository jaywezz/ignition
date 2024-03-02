import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as myget;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/requisitions/requisition_products.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../../controllers/customer_checking_controller.dart';
import '../../../controllers/customers_controller.dart';
import '../../../helper/dio_exceptions.dart';

final addStockLiftRepo =
Provider<AddStockLiftRepositoryAPI>((ref) => AddStockLiftRepositoryAPI(ref));

class AddStockLiftRepositoryAPI{
  final Ref read;
  AddStockLiftRepositoryAPI(this.read);

  Future<Response> addStockLift(var cartData, File receiptFile, String distributorId, String warehouseCode) async {
    print(cartData);
    FormData data1 = FormData.fromMap(
        {
          "products":cartData,
          "distributor": distributorId,
          "warehouseCode": warehouseCode,
        }
    );
    data1.files.add(MapEntry(
          "image", await MultipartFile.fromFile(receiptFile.path, filename: "stockLiftReceipt_${DateTime.now()}_${receiptFile.path.toString().split(".").last}",),
        ));
    return await read.read(clientProvider).post("/stocklift", data:data1);
  }

  Future<Response> addRequisitionProducts(var cartData, String requisitionId) async {
    print(cartData);
    var data = {"requistion_id": requisitionId, "products": cartData};
    return await read.read(clientProvider).post("/stock/accept", data:data);
  }

  Future<Response> stockRequisition(var cartData, String warehouseCode) async {
    print(cartData);
    return await read.read(clientProvider).post("/stock/create/request/$warehouseCode", data:cartData);
  }

  Future<Response> editStockRequisition(var cartData, String requisitionId) async {
    print(cartData);
    return await read.read(clientProvider).post("/stock/create/requests", data:cartData);
  }


  Future<List<ProductsModel>> getWarehouseProducts(String warehouseCode) async {
    try {
      final response = await read.read(clientProvider).get("/products/warehouse/${warehouseCode}");
      final products = productsFromJson(response.data["data"]);

      return products;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
  Future<List<RequisitionModel>> getRequisitions() async {
    try {
      final response = await read.read(clientProvider).get("/stock/requisitions");
      print("the response: $response");
      final requisitions = requisitionsFromJson(response.data);

      return requisitions;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e){
      print(e);
      throw e;
    }
  }

  Future<List<DistributorsModel>> getDistributors() async {
    try {
      final response = await read.read(clientProvider).get("/distributors");
      print("the response: $response");
      final distributors = distributorsJson(response.data["Data"]);
      print("distrbutor list: $distributors");

      return distributors;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e){
      print("the error $e");
      throw e;
    }
  }

  Future<List<WarehouseModel>> getWarehouses() async {
    try {
      final response = await read.read(clientProvider).get("/get/warehouses");
      print("the response: $response");
      final warehouses = wareHousesFromJson(response.data["data"]);
      print("distrbutor list: $warehouses");

      return warehouses;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e){
      print("the error $e");
      throw e;
    }
  }

}
