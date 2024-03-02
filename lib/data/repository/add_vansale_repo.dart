import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as myget;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/requisitions/requisition_products.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../../controllers/customer_checking_controller.dart';
import '../../../controllers/customers_controller.dart';
import '../../../helper/dio_exceptions.dart';

final vanSaleRepo =
Provider<VanSaleRepositoryAPI>((ref) => VanSaleRepositoryAPI(ref));

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class VanSaleRepositoryAPI{
  final Ref read;
  VanSaleRepositoryAPI(this.read);

  Future<Response> addVanSale(var cartData, String discount) async {
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("checking code : ${prefs.getString('checkinCode')}");
    print(cartData);
    // var data = {"cartItem": cartData};
    return await read.read(clientProvider).post("/checkin/vansales/${prefs.getInt('customerId')}/${getRandomString(10)}/add-to-cart", data:cartData);
  }



}
