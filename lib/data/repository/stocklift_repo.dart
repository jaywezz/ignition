import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dioCast;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import 'package:dio/dio.dart' as d;
import '../api_service/api_client.dart';

class AddStockLiftRepo {
  final ApiClient apiClient;

  AddStockLiftRepo({required this.apiClient});

  Future<Response> getDistributors() async{
    String DISTRIBUTORS ='/distributors';

    return await apiClient.getData(DISTRIBUTORS);
  }
  Future<Response> getDistributorsProducts(String distributorId) async{
    String DISTRIBUTORPRODUCTS ='/stocklift/show?supplierID=$distributorId}';
    return await apiClient.getData(DISTRIBUTORPRODUCTS);
  }
}