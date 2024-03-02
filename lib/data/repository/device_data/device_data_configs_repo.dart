import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as myget;
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/company_routes/company_routes_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';

import '../../../controllers/customer_checking_controller.dart';
import '../../../controllers/customers_controller.dart';
import '../../../helper/dio_exceptions.dart';
import '../../providers/client_provider.dart';

final deviceDataConfigsRepo =
Provider<DeviceDataConfigsRepo>((ref) => DeviceDataConfigsRepo(ref));


class DeviceDataConfigsRepo{
  final Ref read;
  DeviceDataConfigsRepo(this.read);

  Future sendPhoneInfoAndLocation(String latitude, String longitude,
      ) async {
    String batteryLevel = "0";
    String fcm_token = "";
    await FirebaseMessaging.instance.getToken().then((value){
            fcm_token = value!;
      },
    );
    var battery = Battery();
    await battery.batteryLevel.then((value) => batteryLevel = value.toString());

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> _deviceData = <String, dynamic>{};
    _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);

    var data = {
      "current_gps": "$latitude,$longitude",
      "current_battery_percentage": batteryLevel,
      "device_code": "device_code",
      "IMEI": _deviceData["id"],
      "fcm_token": fcm_token,
      "android_version": _deviceData["version.release"]
    };
    print("device data: $data");
    try {
      final result = await read.read(clientProvider).post("/current/device/information", data: data);
      return result.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
      ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
    };
  }
}
