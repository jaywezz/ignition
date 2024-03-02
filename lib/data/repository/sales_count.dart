import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../helper/dio_exceptions.dart';
import '../../models/salesCountModel/sales_count.dart';

//
// final clientProvider = Provider((ref) => Dio(BaseOptions(headers: {
//       "Authorization": "Bearer 580|T4n6aVr15pbmXSweS18gHvVp8bDhGRMtjuhuNxBc",
//     }, baseUrl: 'http://172.104.245.14/sokoflowadmin/api/')));
final salesCountRepositoryProvider =
    Provider<SalesCountRepositoryAPI>((ref) => SalesCountRepositoryAPI(ref));

abstract class SalesCountRepository {
  Future<SalesCount> getSalesCount();
}

class SalesCountRepositoryAPI implements SalesCountRepository {
  final Ref ref;
  SalesCountRepositoryAPI(this.ref);

  @override
  Future<SalesCount> getSalesCount() async {
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(SalesCountClassAdapter());
    }
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await ref.read(clientProvider).get("/SalesMade");
      final sales = SalesCount.fromJson(response.data);

      HiveDataManager(HiveBoxConstants.salesCountDb).addHiveData(sales);

      print(response.data);
      return sales;
    } on DioError catch (e) {
      print(e);
      if (e.message!.contains("SocketException")) {
        // print("leads from db offline ${ getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );
        showCustomSnackBar("No internet. Using offline data");
        return HiveDataManager(HiveBoxConstants.salesCountDb)
            .getHiveData()
            .then((box) => box.get(HiveBoxConstants.salesCountDb));
      }
      if (e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectTimeout) {
        // print("leads from db offline ${  getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );

        showCustomSnackBar("Connection timeout. Using offline data");
        return HiveDataManager(HiveBoxConstants.salesCountDb)
            .getHiveData()
            .then((box) => box.get(HiveBoxConstants.salesCountDb));
      }
      throw DioExceptions.fromDioError(e);
    }
  }
}
