import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/reports_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

final salesRepositoryProvider =
    Provider<SalesRepository>((ref) => SalesRepository(ref));

class SalesRepository extends StateNotifier {
  final Ref _reader;

  SalesRepository(this._reader) : super(0);

  Future<Reports> getSalesReports() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response =
          await _reader.read(clientProvider).get(AppConstants.GET_REPORTS);
      print("the response: $response");
      final reports = Reports.fromJson(response.data["Data"]);
      print("the data: $reports");

      return reports;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      print("error: $e");
      throw e;
    }
  }
}
