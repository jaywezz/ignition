import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as myget;
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/company_routes/company_routes_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';

import '../../../controllers/customer_checking_controller.dart';
import '../../../controllers/customers_controller.dart';
import '../../../helper/dio_exceptions.dart';
import '../../../models/company_outlets/customer_groups.dart';
import '../../providers/client_provider.dart';

final CustomerRepositoryProvider =
    Provider<CustomerRepositoryAPI>((ref) => CustomerRepositoryAPI(ref));

abstract class CustomerRepository {
  Future addCustomer(
      String customer_name,
      String email,
      String contact_person,
      String business_code,
      String created_by,
      String phone_number,
      String alternativePhone,
      String outlet,
      String latitude,
      String longitude,
      String address,
      String routeCode,
      File file);
}

class CustomerRepositoryAPI implements CustomerRepository {
  final Ref read;
  CustomerRepositoryAPI(this.read);

  @override
  Future addCustomer(
      String customer_name,
      String email,
      String contact_person,
      String business_code,
      String created_by,
      String phone_number,
      String alternativePhone,
      String outlet,
      String latitude,
      String longitude,
      String routeCode,
      String address,
      File? file) async {
    try {
      if (file == null) {
        Directory directory = await getApplicationDocumentsDirectory();
        var dbPath = join(directory.path, "app.txt");
        ByteData data = await rootBundle.load("assets/logo/playstore.png");
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        file = await File(dbPath).writeAsBytes(bytes);
      }
      FormData formData = FormData.fromMap({
        "customer_name": customer_name,
        "email": email,
        "contact_person": contact_person,
        "business_code": business_code,
        "created_by": created_by,
        "route_code": routeCode,
        "phone_number": phone_number,
        "alternative_phone": alternativePhone,
        "outlet": outlet,
        "latitude": latitude,
        "longitude": longitude,
        'address': address,
        "image": await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });
      final result = await read
          .read(clientProvider)
          .post("/customers/add-customer", data: formData);

      myget.Get.find<CustomerCheckingController>().geofenceService.stop();
      await myget.Get.find<CustomersController>().getCustomers(50, true);
      myget.Get.find<CustomerCheckingController>()
          .geofenceService
          .start(
              myget.Get.find<CustomerCheckingController>().lstCustomerGeofences)
          .catchError(myget.Get.find<CustomerCheckingController>().onError);
      return result.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }catch(e){
      print("error: ${e}");
      throw e;
    }
  }

  Future editCustomer({
    required String customer_name,
    required String email,
    required businessCode,
    required String contact_person,
    required String phone_number,
    required String alternativePhone,
    required String? outlet,
    required String? latitude,
    required String? longitude,
    required String? routeCode,
    required String? address,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int customerId = await prefs.getInt("customerId")!;
      var data = {
        "id": customerId,
        "customer_name": customer_name,
        "account": null,
        "business_code": businessCode,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "contact_person": null,
        "customer_group": null,
        "price_group": outlet,
        "approval": null,
        "status": null,
        "telephone": phone_number,
        "manufacturer_number": null,
        "vat_number": null,
        "delivery_time": null,
        "city": null,
        "province": null,
        "postal_code": null,
        "country": null,
        "customer_secondary_group": null,
        "branch": null,
        "email": email,
        "phone_number": phone_number
      };
      final result = await read
          .read(clientProvider)
          .post("/customer/edit-customer", data: data);

      myget.Get.find<CustomerCheckingController>().geofenceService.stop();
      await myget.Get.find<CustomersController>().getCustomers(500, true);
      myget.Get.find<CustomerCheckingController>()
          .geofenceService
          .start(
              myget.Get.find<CustomerCheckingController>().lstCustomerGeofences)
          .catchError(myget.Get.find<CustomerCheckingController>().onError);
      return result.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<CustomerGroupModel>?> getCustomerGroups(bool isSync) async {
    List<CustomerGroupModel> outlets = [];
    try {
      await HiveDataManager(HiveBoxConstants.customerGroupDb)
          .getHiveData()
          .then((box) {
        if (box.isNotEmpty) {
          outlets.addAll(box
              .get(HiveBoxConstants.customerGroupDb)
              .cast<CustomerGroupModel>());
        }
      });
      if (outlets.isNotEmpty && isSync == false) {
        print("getting outlets offline");
        return outlets;
      } else {
        print("getting outlets online");
        final response =
            await read.read(clientProvider).get("/customer/groups");
        Logger().e(response.data);
        outlets = customerGroupsFromJson(response.data["data"]);
        HiveDataManager(HiveBoxConstants.customerGroupDb).addHiveData(outlets);
        print("the $outlets");
        return outlets;
      }
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      throw e;
    }
  }

  Future<List<CompanyOutletsModel>?> getOutlets(bool isSync) async {
    List<CompanyOutletsModel> outlets = [];
    try {
      await HiveDataManager(HiveBoxConstants.outletsDb)
          .getHiveData()
          .then((box) {
        if (box.isNotEmpty) {
          outlets.addAll(
              box.get(HiveBoxConstants.outletsDb).cast<CompanyOutletsModel>());
        }
      });
      if (outlets.isNotEmpty && isSync == false) {
        print("getting outlets offline");
        return outlets;
      } else {
        print("getting outlets online");
        final response =
            await read.read(clientProvider).get("/get/outlet/types");
        outlets = companyOutletsFromJson(response.data["outlets"]);
        HiveDataManager(HiveBoxConstants.outletsDb).addHiveData(outlets);
        print("the $outlets");
        return outlets;
      }
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e) {
      throw e;
    }
  }

  Future<List<Subregion>> getRoutes(bool isSync) async {
    // Box boxRoutes = await Hive.openBox<List<Subregion>>(HiveBoxConstants.routesDb);
    List<Subregion> routes = [];
    try {
      await HiveDataManager(HiveBoxConstants.routesDb)
          .getHiveData()
          .then((box) {
        if (box.isNotEmpty) {
          routes.addAll(box.get(HiveBoxConstants.routesDb).cast<Subregion>());
        }
      });
      if (routes.isNotEmpty && isSync == false) {
        print("getting outlets offline");
        return routes;
      } else {
        print("getting outlets online");
        final response = await read.read(clientProvider).get("/total/routes");
        print("routes response: ${response.data}");
        final routes =
            companyRoutesFromJson(response.data["data"][0]["subregion"]);
        HiveDataManager(HiveBoxConstants.routesDb).addHiveData(routes);
        return routes;
      }
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    } catch (e, s) {
      print(s);
      throw e;
    }
  }

  Future<Response> submitCheckoutForm(var data, File? file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String checkinCode = await prefs.getString('checkinCode')!;
      int customerId = await prefs.getInt('customerId')!;
      FormData data1 = FormData.fromMap(data);
      if (file != null) {
        data1.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            file.path,
            filename:
            "shop_image_${DateTime.now()}_${file.path.toString().split(".").last}",
          ),
        ));
      }
      return await read
          .read(clientProvider)
          .post("/form/responses/$customerId/${checkinCode}", data: data1);
    } catch (e, s) {
      print(e);
      throw e.toString();
    }
  }

}
