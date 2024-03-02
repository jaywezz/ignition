import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/targets/targets_model.dart';
import 'package:soko_flow/utils/app_constants.dart';
final onBoardPermissionsRepositoryProvider =
Provider<OnBoardPermissionsRepository>((ref) => OnBoardPermissionsRepository(ref));

class OnBoardPermissionsRepository {
  final Ref ref;
  OnBoardPermissionsRepository(this.ref);

  Future<Response> getPermissions() async {
    try {
      final response = await ref.read(clientProvider).get("/get/permissions");
      return response;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<Response> getCustomerCreditorStatus(String customerId) async {
    try {
      final response = await ref.read(clientProvider).post("/customer/creditor/status", data: {
        "customer_id": customerId,
      });
      return response;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e){
      throw e;
    }
  }

  Future<Response> requestCreditorStatus(String customerId) async {
    try {
      final response = await ref.read(clientProvider).post("/customer/request/toBeCreditor", data: {
        "customer_id": customerId,
      });
      return response;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e){
      throw e;
    }
  }
}
