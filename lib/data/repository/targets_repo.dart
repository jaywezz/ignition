import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/data/repository/sales_count.dart';
import 'package:soko_flow/models/targets/targets_model.dart';
import 'package:soko_flow/models/visitCountModel/visit_count.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../helper/dio_exceptions.dart';

final targetsRepositoryProvider =
Provider<TargetsRepositoryAPI>((ref) => TargetsRepositoryAPI(ref));

class TargetsRepositoryAPI {
  final Ref ref;
  TargetsRepositoryAPI(this.ref);

  Future<Target> getTargets() async {
    // if(!Hive.isAdapterRegistered(8)){
    //   Hive.registerAdapter(VisitCountClassAdapter());
    // }
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await ref.read(clientProvider).get("/get/targets");
      print("targets on response: ${response.data["Targets"]["target_sale"]}");
      final targets = targetsFromJson(response.data["Targets"]);
      print("after: ${targets.targetSales}");
      //
      // HiveDataManager(HiveBoxConstants.customerVisitsDb).addHiveData(visits);
      print("targets on model: $targets");
      return targets;
    } on DioError catch (e) {
      // if(e.message.contains("SocketException")){
      //   // print("leads from db offline ${ getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );
      //   showCustomSnackBar("No internet. Using offline data");
      //   return  HiveDataManager(HiveBoxConstants.customerVisitsDb).getHiveData().then((box)
      //   => box.get(HiveBoxConstants.customerVisitsDb));
      // }
      // if(e.type == DioErrorType.receiveTimeout || e.type == DioErrorType.connectTimeout){
      //   // print("leads from db offline ${  getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );
      //
      //   showCustomSnackBar("Connection timeout. Using offline data");
      //   return  HiveDataManager(HiveBoxConstants.customerVisitsDb).getHiveData().then((box)
      //   => box.get(HiveBoxConstants.customerVisitsDb));
      // }
      throw DioExceptions.fromDioError(e);
    }catch(e,s){
      print("an error $s");
      throw e;
    }
  }
}
