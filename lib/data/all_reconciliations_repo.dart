import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/reconcile/reconciliations_list_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../../helper/dio_exceptions.dart';


final allReconciliationRepo =
Provider<AllReconciliationsRepositoryAPI>((ref) => AllReconciliationsRepositoryAPI(ref));

class AllReconciliationsRepositoryAPI{
  final Ref read;
  AllReconciliationsRepositoryAPI(this.read);


  Future<List<ReconciliationListModel>> getAllReconciliations(bool isSync) async {
    try {
      final response = await read.read(clientProvider).get("/reconciliations");
      final reconciliations = reconciliationsListFromJson(response.data["reconciliations"]);
      return reconciliations;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e,s){
      print(e);
      print(s);
      throw e;
    }
  }
}
