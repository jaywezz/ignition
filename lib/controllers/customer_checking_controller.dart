import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/utils/generate_codes.dart';

import '../data/hive_database/hive_manager.dart';
import '../models/customer_checkin.dart';
import 'package:http/http.dart' as http;

import '../models/customer_model/customer_model.dart';

class CustomerCheckingController extends GetxController {
  final geofenceService = GeofenceService.instance.setup(
      interval: 7000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: false,
      allowMockLocations: true,
      printDevLog: true,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  final _activityStreamController = StreamController<Activity>();
  var geofenceStreamController = StreamController<Geofence>.broadcast();

  bool isAtCustomerLocation = false;

  @override
  void onInit() {
    // TODO: implement onInit
    print("widget reinitiliazed");

    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      geofenceService.addLocationChangeListener(_onLocationChanged);
      geofenceService.addLocationServicesStatusChangeListener(
          _onLocationServicesStatusChanged);
      geofenceService.addActivityChangeListener(_onActivityChanged);
      geofenceService.addStreamErrorListener(_onError);
      // geofenceService.start(lstCustomerGeofences).catchError(_onError);
    });
  }

  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  //
  //   print("closing customer checking ctrl");
  //   // activityStreamController.close();
  //   // geofenceService.clearAllListeners();
  //   // geofenceStreamController.close();
  //   // dispose();
  // }

  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  // This function is to be called when the geofence status is changed.
  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (geofenceStatus == GeofenceStatus.EXIT) {

      String? checkinCode = await prefs.getString('checkinCode');
      Get.find<CustomerCheckingController>().activeGeofences.remove(geofence);
      // if(checkinCode !=null){
      //   await customerCheckout(checkinCode);
      //   Get.back();
      // }
    } else if (geofenceStatus == GeofenceStatus.ENTER) {
      Get.find<CustomerCheckingController>().activeGeofences.add(geofence);
    }
    // print('geofence: ${geofence.toJson()}');
    // _log.i('geofence: ${geofence.toJson()}');
    // print('geofenceRadius: ${geofenceRadius.toJson()}');
    // print('geofenceStatus: ${geofenceStatus.toString()}');
    geofenceStreamController.sink.add(geofence);
  }

  // This function is to be called when the activity has changed.
  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    // activityStreamController.sink.add(currActivity);
  }

  // This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    // print('location: ${location.toJson()}');
  }

  // This function is to be called when a location services status change occurs
  // since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

  // This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  //Has a list of all the geofences available neear user location
  List<Geofence> activeGeofences = List<Geofence>.empty(growable: true).obs;
  //A list of all the customer geofences
  List<Geofence> lstCustomerGeofences1 = <Geofence>[];
  List<Geofence> lstCustomerGeofences = <Geofence>[];

  Future<bool> addCustomerGeofences(List<CustomerDataModel> customers) async {
    print("adding geofences");

    customers.forEach((customer) {
      lstCustomerGeofences.add(Geofence(
        id: customer.id.toString(),
        latitude: double.parse(customer.latitude!),
        longitude: double.parse(customer.longitude!),
        radius: [
          GeofenceRadius(id: 'radius_10m', length: 500),
          GeofenceRadius(id: 'radius_100m', length: 1000),
        ],
      ));
    });
    if (!Get.find<CustomerCheckingController>()
        .geofenceService
        .isRunningService) {
      Get.find<CustomerCheckingController>()
          .geofenceService
          .start(Get.find<CustomerCheckingController>().lstCustomerGeofences)
          .catchError(Get.find<CustomerCheckingController>().onError);
    }
    update();
    print("added geofences");
    return true;
  }

  addCheckingData(
      String checkingCode,
      int customerId,
      String customerName,
      String customerAddress,
      String customerEmail,
      String customerPhone,
      String lat,
      String long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("code at checkin: ${checkingCode}");
    prefs.setString('checkinCode', checkingCode);
    prefs.setInt('customerId', customerId);
    prefs.setString('customerName', customerName);
    prefs.setString('customerAddress', customerAddress);
    prefs.setString('customerEmail', customerEmail);
    prefs.setString('customerPhone', customerPhone);
    prefs.setString('lat', lat);
    prefs.setString('long', long);
  }

  Future<CustomerCheckinModel> createCheckinSession(String latitude,
      String longitude, String customerId, String user_code) async {
    print("creating a checking session : $latitude");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userCode = await prefs.getString(AppConstants.USER_CODE);
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.BASE_URL}/customer/checkin/session/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.getString(AppConstants.TOKEN)}'
        },
        body: jsonEncode(
          {
            "customerID": customerId,
            "latitude": latitude,
            "longitude": longitude,
            "user_code": userCode,
          },
        ),
      );
      print("repsonse: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        showCustomSnackBar("You have successfully checked in.",
            // Colors.blue,
            isError: false);
        return CustomerCheckinModel.fromJson(data);
      } else {
        showCustomSnackBar("Failed to create checkin session.", isError: true);
        throw Exception("Failed to checkin Customer!");
      }
    } catch (exception) {
      print("doing offline checking: ${exception.toString()}");
      if (exception.toString() == "Connection failed") {
        print("doing offline checking: ${exception.toString()}");
        var r = Random();
        String checkingcode = generateRandomString(20);
        print("adding an offline  checkin");
        List checkins = [];
        await HiveDataManager(HiveBoxConstants.customerCheckins)
            .getHiveData()
            .then((value) {
          print(
              "checkin data offline: ${value.get(HiveBoxConstants.customerCheckins)}");
          checkins.addAll(value.get(HiveBoxConstants.customerCheckins));
        });
        checkins.add(
          {
            "customerID": customerId,
            "checkin_code": checkingcode,
            // "startTime": ,
            "latitude": latitude,
            "longitude": longitude,
            "user_code": user_code,
          },
        );

        await HiveDataManager(HiveBoxConstants.customerCheckins)
            .addHiveData(checkins);

        print("all checkins: $checkins");

        CustomerCheckinModel checkinModel = CustomerCheckinModel(
            success: true,
            message: "Offline Check in",
            checkingCode: checkingcode);
        showCustomSnackBar("Successful offline Check in", isError: false);
        return checkinModel;
      } else {
        print("no connection");
        showCustomSnackBar("An error occurred checking in", isError: true);
        return Future.error(exception.toString());
      }
    }
  }

  removeCheckinPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('checkinCode');
    prefs.remove('customerId');
    prefs.remove('customerName');
    prefs.remove('customerAddress');
    prefs.remove('customerEmail');
    prefs.remove('customerPhone');
  }

  Future customerCheckout(String checkinCode) async {
    try {
      final response = await http.get(
          Uri.parse("${AppConstants.BASE_URL}/checkin/${checkinCode}/out"));
      print("Response StatusCode---> ${response.statusCode}");
      if (response.statusCode == 200) {
        showCustomSnackBar("You have successfully checked out.",
            isError: false);

        // Colors.blue,
        removeCheckinPrefs();
        return json.decode(response.body);
      } else {
        showCustomSnackBar("Checkout failed, Please try again.....",
            isError: true);
      }
    } catch (e) {
      showCustomSnackBar("${e.toString()}", isError: true);
      return Future.error(e.toString());
    }
  }

  UserCustomerLocation checkUserCustomerLocation(
      String id, double latitude, double longitude) {
    Geofence currentGeofence = Geofence(
      id: id,
      latitude: latitude,
      longitude: longitude,
      radius: [
        GeofenceRadius(id: 'radius_10m', length: 10),
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    );
    // print("the current geofence lat: ${currentGeofence.latitude}, geofence long: ${currentGeofence.longitude}");
    var contain = activeGeofences.where((element) => element.id == id);
    if (contain.isNotEmpty) {
      //find the geofence
      final ind = activeGeofences.indexWhere((element) => element.id == id);
      if (ind >= 0) {
        Geofence fence = activeGeofences[ind];
        if (fence.radius[0].status != GeofenceStatus.EXIT) {
          // print("is 10 meters close");

          isAtCustomerLocation = true;
          // update();
          return UserCustomerLocation.CURRENT;
        } else if (fence.radius[1].status != GeofenceStatus.EXIT) {
          // print("is 100 meters close");
          return UserCustomerLocation.CLOSE;
        }
      }
    }
    return UserCustomerLocation.NONE;
  }

  void onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }
}

enum UserCustomerLocation { CLOSE, CURRENT, NONE }
