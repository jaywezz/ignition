import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/data/repository/sales_count.dart';
import 'package:soko_flow/models/leadsModel/new_leads.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../helper/dio_exceptions.dart';

final newLeadsRepositoryProvider =
    Provider<NewLeadsRepositoryAPI>((ref) => NewLeadsRepositoryAPI(ref));

abstract class NewLeadsRepository {
  Future<NewLeads> getNewLeads();
}

class NewLeadsRepositoryAPI implements NewLeadsRepository {
  final Ref ref;
  NewLeadsRepositoryAPI(this.ref);

  @override
  Future<NewLeads> getNewLeads() async {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(NewLeadsClassAdapter());
    }

    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await ref.read(clientProvider).get("/NewLeads");
      final leads = NewLeads.fromJson(response.data);
      print(leads);

      //Add data to hive any time there is internet connection
      HiveDataManager(HiveBoxConstants.newLeadsDb).addHiveData(leads);
      return leads;
    } on DioError catch (e) {
      if (e.message!.contains("SocketException")) {
        // print("leads from db offline ${ getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );
        // showCustomSnackBar("No internet. Using offline data");
        return HiveDataManager(HiveBoxConstants.newLeadsDb)
            .getHiveData()
            .then((box) => box.get(HiveBoxConstants.newLeadsDb));
      }
      if (e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectTimeout) {
        // print("leads from db offline ${  getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );

        // showCustomSnackBar("Connection timeout. Using offline data");
        return HiveDataManager(HiveBoxConstants.newLeadsDb)
            .getHiveData()
            .then((box) => box.get(HiveBoxConstants.newLeadsDb));
      }

      throw DioExceptions.fromDioError(e);
    }
  }
}
