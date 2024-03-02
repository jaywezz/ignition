import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/models/response_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

final deliveriesRepositoryProvider =
    Provider<DeliveriesRepository>((ref) => DeliveriesRepository(ref));

class DeliveriesRepository extends StateNotifier {
  final Ref _reader;

  DeliveriesRepository(this._reader) : super(0);

  Future<List<DeliveriesModel>> getUserDeliveries() async {
    print("getting deliveries");
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await _reader.read(clientProvider).get(AppConstants.USER_DELIVERIES);
      print("some data ${response.data["deliveries"]}");
      final leads = deliveriesFromJson(response.data["deliveries"]);
      print("some deliveries $leads");
      return leads;
    } on DioError catch (e) {
      print(e);
      throw DioExceptions.fromDioError(e);
    } catch (e, s) {
      print(e);
      throw e;
    }
  }

  Future<Response> makePartialDelivery(var data, String deliveryCode)async{
    try{
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await _reader.read(clientProvider).post("/partial/delivery/$deliveryCode", data: data);
      return response;
    } on DioError catch (e) {
      print(e);
      throw DioExceptions.fromDioError(e);
    } catch (e, s) {
      print(s);
      throw e;
    }
  }


  Future<Response> makeFullDelivery(var data, String deliveryCode)async{
    try{
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await _reader.read(clientProvider).post("/full/delivery/$deliveryCode", data: data);
      return response;
    } on DioError catch (e) {
      print(e);
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      print(e);
      throw e;
    }
  }
  Future<Response> cancelDelivery(var data, String deliveryCode)async{
    state = AsyncValue.loading();
    try{
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await _reader.read(clientProvider).post("/cancel/delivery/$deliveryCode", data: data);
      return response;
    } on DioError catch (e) {
      print(e);
      state = AsyncValue.data(null);
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      print(e);
      state = AsyncValue.data(null);
      throw e;
    }

  }

  Future<Response> acceptDelivery(List<String> deliveryCode)async{
    var data = [];
    for(String deliveryCode in deliveryCode){
      data.add({"delivery_code":deliveryCode, "note":"", });
    }
    try{
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await _reader.read(clientProvider).post("/accept/delivery", data: data);
      return response;
    } on DioError catch (e) {
      print(e);
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Response> rejectDelivery(List<String> deliveryCode, String note)async{
    var data = [];
    for(String deliveryCode in deliveryCode){
      data.add({"delivery_code":deliveryCode, "note":note});
    }
    try{
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await _reader.read(clientProvider).post("/reject/delivery", data: data);
      return response;
    } on DioError catch (e) {
      print(e);
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      print(e);
      throw e;
    }
  }

}
