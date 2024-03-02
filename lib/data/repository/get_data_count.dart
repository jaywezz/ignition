import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/models/visitCountModel/visit_count.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../helper/dio_exceptions.dart';

final customerVisitsOrderRepo = Provider.autoDispose<CustomerVisitsOrder>(
    (ref) => CustomerVisitsOrder(ref));

class CustomerVisitsOrder {
  final Ref ref;
  CustomerVisitsOrder(this.ref);

  Future<Response> getVisitOrder(String customer_id) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      final response =
          await ref.read(clientProvider).get("/get/count/$customer_id");

      return response;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
