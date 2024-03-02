import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/data/repository/sales_count.dart';
import 'package:soko_flow/models/ordersCountModel/orders_count.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../helper/dio_exceptions.dart';

final ordersCountRepositoryProvider =
    Provider<OrdersCountRepositoryAPI>((ref) => OrdersCountRepositoryAPI(ref));

abstract class OrdersCountRepository {
  Future<OrdersCount> getOrdersCount();
}

class OrdersCountRepositoryAPI implements OrdersCountRepository {
  final Ref ref;
  OrdersCountRepositoryAPI(this.ref);

  @override
  Future<OrdersCount> getOrdersCount() async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(OrdersCountClassAdapter());
    }
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response = await ref.read(clientProvider).get("/countOrders");
      final orders = OrdersCount.fromJson(response.data);
      HiveDataManager(HiveBoxConstants.orderCountDb).addHiveData(orders);
      print(orders);
      return orders;
    } on DioError catch (e) {
      if (e.message!.contains("SocketException")) {
        // print("leads from db offline ${ getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );
        showCustomSnackBar("No internet. Using offline data");
        return HiveDataManager(HiveBoxConstants.orderCountDb)
            .getHiveData()
            .then((box) => box.get(HiveBoxConstants.orderCountDb));
      }
      if (e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectTimeout) {
        // print("leads from db offline ${  getHiveData(HiveBoxConstants.newLeadsDb).get(HiveBoxConstants.newLeadsDb)}" );

        showCustomSnackBar("Connection timeout. Using offline data");
        return HiveDataManager(HiveBoxConstants.orderCountDb)
            .getHiveData()
            .then((box) => box.get(HiveBoxConstants.orderCountDb));
      }
      throw DioExceptions.fromDioError(e);
    }
  }
}
